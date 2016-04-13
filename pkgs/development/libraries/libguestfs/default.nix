{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, ncurses, cpio, gperf, perl, cdrkit, flex, bison, qemu, pcre, augeas, libxml2
, acl, libcap, libcap_ng, libconfig, systemd, fuse, yajl, libvirt, hivex
, gmp, readline, file, libintlperl, GetoptLong, SysVirt, numactl, xen }:

stdenv.mkDerivation rec {
  name = "libguestfs-${version}";
  version = "1.29.5";

  appliance = fetchurl {
    url = "http://libguestfs.org/download/binaries/appliance/appliance-1.26.0.tar.xz";
    sha256 = "1kzvgmy845kclvr93y6rdpss2q0p8yfqg14r0i1pi5r4zc68yvj4";
  };

  src = fetchurl {
    url = "http://libguestfs.org/download/1.29-development/libguestfs-${version}.tar.gz";
    sha256 = "1il0p3irwcyfdm83935hj4bvxsx0kdfn8dvqmg2lbzap17jvzj8h";
  };

  buildInputs = [
    makeWrapper pkgconfig autoreconfHook ncurses cpio gperf perl
    cdrkit flex bison qemu pcre augeas libxml2 acl libcap libcap_ng libconfig
    systemd fuse yajl libvirt gmp readline file hivex libintlperl GetoptLong
    SysVirt numactl xen
  ];

  configureFlags = "--disable-appliance --disable-daemon";
  patches = [ ./libguestfs-syms.patch ];
  NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2/";

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix "PATH" : "$out/bin:${hivex}/bin" \
        --prefix "PERL5LIB" : "$PERL5LIB:$out/lib/perl5/site_perl"
    done
  '';

  postFixup = ''
    mkdir -p "$out/lib/guestfs"
    tar -Jxvf "$appliance" --strip 1 -C "$out/lib/guestfs"
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
