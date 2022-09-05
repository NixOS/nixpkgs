{ lib
, stdenv
, fetchurl
, pkg-config
, autoreconfHook
, makeWrapper
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
}:

assert appliance == null || lib.isDerivation appliance;

stdenv.mkDerivation rec {
  pname = "libguestfs";
  version = "1.48.4";

  src = fetchurl {
    url = "https://libguestfs.org/download/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-ncIrbFpF8ZwsupEaN7Oo2G9idEUhsQ61PD05B+UIAxI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
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
  ] ++ (with perlPackages; [ perl libintl-perl GetoptLong ModuleBuild ])
  ++ (with ocamlPackages; [ ocaml findlib ]);
  buildInputs = [
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
    hivex
    db
    numactl
    libapparmor
    perlPackages.ModuleBuild
    libtirpc
  ] ++ (with ocamlPackages; [ ocamlbuild ocaml_libvirt gettext-stub ounit ])
  ++ lib.optional javaSupport jdk;

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
  configureFlags = [
    "--disable-appliance"
    "--disable-daemon"
    "--with-distro=NixOS"
    "--with-guestfs-path=${placeholder "out"}/lib/guestfs"
  ] ++ lib.optionals (!javaSupport) [ "--without-java" ];
  patches = [
    ./libguestfs-syms.patch
  ];

  createFindlibDestdir = true;

  installFlags = [ "REALLY_INSTALL=yes" ];
  enableParallelBuilding = true;

  postInstall = ''
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

  doInstallCheck = appliance != null;
  installCheckPhase = ''
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
  '';

  meta = with lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
    # this is to avoid "output size exceeded"
    hydraPlatforms = if appliance != null then appliance.meta.hydraPlatforms else platforms.linux;
  };
}
