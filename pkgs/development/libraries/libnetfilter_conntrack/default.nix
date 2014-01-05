{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  name = "libnetfilter_conntrack-1.0.4";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnetfilter_conntrack/files/${name}.tar.bz2";
    sha256 = "0zcwjav1qgr7ikmvfmy7g3nc7s1kj4j4939d18mpyha9mwy4mv6r";
  };

  buildInputs = [ pkgconfig libnfnetlink libmnl ];

  meta = {
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
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
