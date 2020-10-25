{ stdenv, fetchurl, pkgconfig, libmnl, libnfnetlink }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  pname = "libnetfilter_queue";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_queue/files/${pname}-${version}.tar.bz2";
    sha256 = "1xdra6i4p8jkv943ygjw646qx8df27f7p5852kc06vjx608krzzr";
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
