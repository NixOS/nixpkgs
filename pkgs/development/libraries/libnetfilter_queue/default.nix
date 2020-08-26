{ stdenv, fetchurl, pkgconfig, libmnl, libnfnetlink }:

stdenv.mkDerivation rec {
  version = "1.0.4";
  pname = "libnetfilter_queue";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_queue/files/${pname}-${version}.tar.bz2";
    sha256 = "0w7s6g8bikch1m4hnxdakpkwgrkw64ikb6wb4v4zvgyiywrk5yai";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl libnfnetlink ];

  meta = with stdenv.lib; {
    homepage = "http://www.netfilter.org/projects/libnetfilter_queue/";
    description = "Userspace API to packets queued by the kernel packet filter";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
