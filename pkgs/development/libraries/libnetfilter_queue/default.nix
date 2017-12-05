{ stdenv, fetchurl, pkgconfig, libmnl, libnfnetlink }:

stdenv.mkDerivation rec {
  name = "libnetfilter_queue-1.0.2";

  src = fetchurl {
    url = "ftp://ftp.netfilter.org/pub/libnetfilter_queue/${name}.tar.bz2";
    sha256 = "0chsmj9ky80068vn458ijz9sh4sk5yc08dw2d6b8yddybpmr1143";
  };

  buildInputs = [ pkgconfig libmnl libnfnetlink ];

  meta = {
    homepage = http://www.netfilter.org/projects/libnetfilter_queue/;
    description = "Userspace API to packets queued by the kernel packet filter";

    platforms = stdenv.lib.platforms.linux;
  };
}
