{ stdenv, fetchurl, SDL, eigen, epoxy, fftw, gtest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "movit-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://movit.sesse.net/${name}.tar.gz";
    sha256 = "1k3qbkxapcplpsx22xh4m4ccp9fhsjfcj3pjzbcnrc51103aklag";
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
