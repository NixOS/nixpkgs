{ stdenv, fetchurl, SDL, eigen, epoxy, fftw, gtest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "movit-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "http://movit.sesse.net/${name}.tar.gz";
    sha256 = "1259iq2ixiprk4mn7ypapinbg2w1sjq1aivzzbbch9i23kcfsd44";
  };

  outputs = [ "out" "dev" ];

  GTEST_DIR = "${gtest}";

  propagatedBuildInputs = [ eigen epoxy ];

  buildInputs = [ SDL fftw gtest pkgconfig ];

  meta = with stdenv.lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = http://movit.sesse.net;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
