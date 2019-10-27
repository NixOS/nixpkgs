{ stdenv, fetchurl, pkgconfig, libmnl, libnfnetlink }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  pname = "libnetfilter_queue";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_queue/files/${pname}-${version}.tar.bz2";
    sha256 = "0x77m1fvbqzz5z64jz59fb6j8dvv8b9pg4fmznqwax4x6imjcncq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl libnfnetlink ];

  meta = with stdenv.lib; {
    homepage = http://www.netfilter.org/projects/libnetfilter_queue/;
    description = "Userspace API to packets queued by the kernel packet filter";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
