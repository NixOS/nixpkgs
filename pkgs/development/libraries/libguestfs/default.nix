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
, javaSupport ? false
, jdk
, zstd
, libguestfs
, testers
}:


stdenv.mkDerivation rec {
  pname = "libguestfs";
  version = "1.50.1";

  src = fetchurl {
    url = "https://libguestfs.org/download/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-Xmhx6I+C5SHjHUQt5qELZJcCN8t5VumdEXsSO1hWWm8=";
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
    zstd
  ] ++ (with perlPackages; [ perl libintl-perl GetoptLong ModuleBuild ])
  ++ (with ocamlPackages; [ ocaml findlib ]);
  buildInputs = [
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
    ./libguestfs_guestfs_path_section.patch
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

  passthru.tests = {
    version = testers.testVersion {
      package = libguestfs;
      command = "libguestfs-test-tool -V";
    };
  };

  meta = with lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
