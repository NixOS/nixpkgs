{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, makeWrapper
, ncurses, cpio, gperf, cdrkit, flex, bison, qemu, pcre, augeas, libxml2
, acl, libcap, libcap_ng, libconfig, systemd, fuse, yajl, libvirt, hivex, db
, gmp, readline, file, numactl, libapparmor, jansson
, getopt, perlPackages, ocamlPackages
, libtirpc
, appliance ? null
, javaSupport ? false, jdk ? null }:

assert appliance == null || lib.isDerivation appliance;
assert javaSupport -> jdk != null;

stdenv.mkDerivation rec {
  pname = "libguestfs";
  version = "1.40.2";

  src = fetchurl {
    url = "https://libguestfs.org/download/1.40-stable/${pname}-${version}.tar.gz";
    sha256 = "ad6562c48c38e922a314cb45a90996843d81045595c4917f66b02a6c2dfe8058";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config ];
  buildInputs = [
    ncurses cpio gperf jansson
    cdrkit flex bison qemu pcre augeas libxml2 acl libcap libcap_ng libconfig
    systemd fuse yajl libvirt gmp readline file hivex db
    numactl libapparmor getopt perlPackages.ModuleBuild
    libtirpc
  ] ++ (with perlPackages; [ perl libintl_perl GetoptLong SysVirt ])
    ++ (with ocamlPackages; [ ocaml findlib ocamlbuild ocaml_libvirt gettext-stub ounit ])
    ++ lib.optional javaSupport jdk;

  prePatch = ''
    # build-time scripts
    substituteInPlace run.in        --replace '#!/bin/bash' '#!${stdenv.shell}'
    substituteInPlace ocaml-link.sh --replace '#!/bin/bash' '#!${stdenv.shell}'

    # $(OCAMLLIB) is read-only "${ocamlPackages.ocaml}/lib/ocaml"
    substituteInPlace ocaml/Makefile.am            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace ocaml/Makefile.in            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.am --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.in --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'

    # some scripts hardcore /usr/bin/env which is not available in the build env
    patchShebangs .
  '';
  configureFlags = [ "--disable-appliance" "--disable-daemon" "--with-distro=NixOS" ]
    ++ lib.optionals (!javaSupport) [ "--disable-java" "--without-java" ];
  patches = [ ./libguestfs-syms.patch ./ocaml-4.12.patch ];
  NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2/";
  installFlags = [ "REALLY_INSTALL=yes" ];
  enableParallelBuilding = true;

  postInstall = ''
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
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
    # this is to avoid "output size exceeded"
    hydraPlatforms = if appliance != null then appliance.meta.hydraPlatforms else platforms.linux;
  };
}
