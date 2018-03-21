{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, ncurses, cpio, gperf, perl, cdrkit, flex, bison, qemu, pcre, augeas, libxml2
, acl, libcap, libcap_ng, libconfig, systemd, fuse, yajl, libvirt, hivex
, gmp, readline, file, libintlperl, GetoptLong, SysVirt, numactl, xen, libapparmor
, getopt, perlPackages, ocamlPackages
, appliance ? null
, javaSupport ? false, jdk ? null }:

assert appliance == null || stdenv.lib.isDerivation appliance;
assert javaSupport -> jdk != null;

stdenv.mkDerivation rec {
  name = "libguestfs-${version}";
  version = "1.38.0";

  src = fetchurl {
    url = "http://libguestfs.org/download/1.38-stable/libguestfs-${version}.tar.gz";
    sha256 = "0cgapiad3x5ggwm097mq62hng3bv91p5gmrikrb6adfaasr1l6m3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    makeWrapper autoreconfHook ncurses cpio gperf perl
    cdrkit flex bison qemu pcre augeas libxml2 acl libcap libcap_ng libconfig
    systemd fuse yajl libvirt gmp readline file hivex libintlperl GetoptLong
    SysVirt numactl xen libapparmor getopt perlPackages.ModuleBuild
  ] ++ (with ocamlPackages; [ ocaml findlib ocamlbuild ocaml_libvirt ocaml_gettext ounit ])
    ++ stdenv.lib.optional javaSupport jdk;

  prePatch = ''
    # build-time scripts
    substituteInPlace run.in        --replace '#!/bin/bash' '#!/bin/sh'
    substituteInPlace ocaml-link.sh --replace '#!/bin/bash' '#!/bin/sh'

    # $(OCAMLLIB) is read-only "${ocamlPackages.ocaml}/lib/ocaml"
    substituteInPlace ocaml/Makefile.am            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace ocaml/Makefile.in            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.am --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.in --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'

    # some scripts hardcore /usr/bin/env which is not available in the build env
    patchShebangs .
  '';
  configureFlags = [ "--disable-appliance" "--disable-daemon" "--with-distro=NixOS" ]
    ++ stdenv.lib.optionals (!javaSupport) [ "--disable-java" "--without-java" ];
  patches = [ ./libguestfs-syms.patch ];
  NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2/";
  installFlags = "REALLY_INSTALL=yes";
  enableParallelBuilding = true;

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH     : "$out/bin:${hivex}/bin:${qemu}/bin" \
        --prefix PERL5LIB : "$out/lib/perl5/site_perl"
    done
  '';

  postFixup = stdenv.lib.optionalString (appliance != null) ''
    mkdir -p $out/{lib,lib64}
    ln -s ${appliance} $out/lib64/guestfs
    ln -s ${appliance} $out/lib/guestfs
  '';

  doInstallCheck = true;
  installCheckPhase = ''
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
  '';

  meta = with stdenv.lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = licenses.gpl2;
    homepage = http://libguestfs.org/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
