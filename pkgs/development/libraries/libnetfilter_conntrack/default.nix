{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  name = "libnetfilter_conntrack-1.0.2";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnetfilter_conntrack/files/${name}.tar.bz2";
    md5 = "447114b5d61bb9a9617ead3217c3d3ff";
  };

  buildInputs = [ pkgconfig libnfnetlink libmnl ];

  meta = {
    description = "userspace library providing an API to the in-kernel connection tracking state table.";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = http://netfilter.org/projects/libnetfilter_conntrack/;
    license = "GPLv2+";

    platforms = stdenv.lib.platforms.linux;
  };
}
