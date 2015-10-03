{ stdenv, fetchurl, SDL, eigen, epoxy, fftw, gtest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "movit-${version}";
  version = "1.1.3";

  src = fetchurl {
    url = "http://movit.sesse.net/${name}.tar.gz";
    sha256 = "0q33h3gfw16gd9k6s3isd7ili2mifw7j1723xpdlc516gggsazw9";
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
