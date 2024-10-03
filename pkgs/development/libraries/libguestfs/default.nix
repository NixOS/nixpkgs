{ lib
, stdenv
, fetchurl
, pkg-config
, autoreconfHook
, makeWrapper
, libxcrypt
, ncurses
, cpio
, gperf
, cdrkit
, flex
, bison
, qemu
, pcre2
, augeas
, libxml2
, acl
, libcap
, libcap_ng
, libconfig
, systemd
, fuse
, yajl
, libvirt
, hivex
, db
, gmp
, readline
, file
, numactl
, libapparmor
, jansson
, getopt
, perlPackages
, ocamlPackages
, libtirpc
, appliance ? null
, javaSupport ? false
, jdk
, zstd
, guestfsdOnly ? false
}:

assert appliance == null || lib.isDerivation appliance;

stdenv.mkDerivation rec {
  pname = "libguestfs";
  version = "1.50.1";

  src = fetchurl {
    url = "https://libguestfs.org/download/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-Xmhx6I+C5SHjHUQt5qELZJcCN8t5VumdEXsSO1hWWm8=";
  };

  strictDeps = true;
  nativeBuildInputs =
    [
      autoreconfHook
      bison
      cdrkit
      cpio
      flex
      getopt
      gperf
      makeWrapper
      pkg-config
      qemu
      zstd
    ]
    ++ (with perlPackages; [
      perl
      libintl-perl
      GetoptLong
      ModuleBuild
    ])
    ++ (with ocamlPackages; [
      ocaml
      findlib
    ]);
  buildInputs =
    [
      libxcrypt
      ncurses
      jansson
      pcre2
      augeas
      libxml2
      acl
      libcap
      libcap_ng
      libconfig
      systemd
      fuse
      yajl
      libvirt
      gmp
      readline
      file
      (hivex.override { inherit ocamlPackages; })
      db
      numactl
      libapparmor
      perlPackages.ModuleBuild
      libtirpc
      zstd
    ]
    ++ (with ocamlPackages; [
      ocamlbuild
      ounit
    ])
    ++ lib.optional javaSupport jdk
    ++ lib.optional guestfsdOnly [ ocamlPackages.augeas ];

  prePatch = ''
    # build-time scripts
    substituteInPlace run.in        --replace '#!/bin/bash' '#!${stdenv.shell}'
    substituteInPlace ocaml-link.sh.in --replace '#!/bin/bash' '#!${stdenv.shell}'

    # $(OCAMLLIB) is read-only "${ocamlPackages.ocaml}/lib/ocaml"
    substituteInPlace ocaml/Makefile.am            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace ocaml/Makefile.in            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'

    # some scripts hardcore /usr/bin/env which is not available in the build env
    patchShebangs .
  '';
  configureFlags =
    [
      "--disable-appliance"
      "--with-distro=NixOS"
      "--with-guestfs-path=${placeholder "out"}/lib/guestfs"
      "CPPFLAGS=-I${libxml2.dev}/include/libxml2"
    ]
    ++ lib.optionals (!guestfsdOnly) [ "--disable-daemon" ]
    ++ lib.optionals guestfsdOnly [
      "--enable-daemon"
      "--enable-install-daemon"
      "--without-qemu"
      "--without-libvirt"
      "--disable-fuse"
      "--disable-erlang"
      "--disable-gobject"
      "--disable-golang"
      "--disable-haskell"
      "--disable-lua"
      "--disable-ocaml"
      "--disable-perl"
      "--disable-php"
      "--disable-python"
      "--disable-ruby"
    ]
    ++ lib.optionals (!javaSupport) [ "--without-java" ];
  patches = [
    ./libguestfs-syms.patch
    ./guestfsd_skip_setenv_systemd.patch
  ];

  createFindlibDestdir = true;

  installFlags = [ "REALLY_INSTALL=yes" ];
  enableParallelBuilding = true;

  installPhase = lib.optionals guestfsdOnly ''
    mkdir -p $out
    cd daemon
    REALLY_INSTALL=yes make install
    runHook postInstall
  '';

  postInstall = lib.optionals (!guestfsdOnly) ''
    mv "$out/lib/ocaml/guestfs" "$OCAMLFIND_DESTDIR/guestfs"
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH     : "$out/bin:${hivex}/bin:${qemu}/bin" \
        --prefix PERL5LIB : "$out/${perlPackages.perl.libPrefix}"
    done
  '';

  postFixup = lib.optionalString (appliance != null) ''
    mkdir -p $out/{lib,lib64}
    ln -s ${appliance} $out/lib64/guestfs
    ln -s ${appliance} $out/lib/guestfs
  '';

  doInstallCheck = (appliance != null) || guestfsdOnly;
  installCheckPhase =
    lib.optionalString (appliance != null) ''
      runHook preInstallCheck

      export HOME=$(mktemp -d) # avoid access to /homeless-shelter/.guestfish

      ${qemu}/bin/qemu-img create -f qcow2 disk1.img 10G

      $out/bin/guestfish <<'EOF'
      add-drive disk1.img
      run
      list-filesystems
      part-disk /dev/sda mbr
      mkfs ext2 /dev/sda1
      list-filesystems
      EOF

      runHook postInstallCheck
    ''
    + lib.optionalString guestfsdOnly ''
      executable_count=$(find $out -type f -executable | wc -l)
      if [ "$executable_count" -ne 1 ]; then
        echo "Error: Expected exactly one executable (guestfsd), but found $executable_count executables."
        exit 1
      fi
    '';

  meta = with lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
    # this is to avoid "output size exceeded"
    hydraPlatforms = if appliance != null then appliance.meta.hydraPlatforms else platforms.linux;
  };
}
