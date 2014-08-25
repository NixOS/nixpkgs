{ stdenv, fetchurl, SDL, eigen, epoxy, fftw, gtest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "movit-${version}";
  version = "1.1.2";

  src = fetchurl {
    url = "http://movit.sesse.net/${name}.tar.gz";
    sha256 = "0jka9l3cx7q09rpz5x6rv6ii8kbgm2vc419gx2rb9rc8sl81hzj1";
  };

  GTEST_DIR = "${gtest}";

  propagatedBuildInputs = [ eigen epoxy ];

  buildInputs = [ SDL fftw gtest pkgconfig ];

  meta = with stdenv.lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = http://movits.sesse.net;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
