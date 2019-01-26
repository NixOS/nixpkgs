{ stdenv, fetchurl, SDL2, eigen, epoxy, fftw, gtest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "movit-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "https://movit.sesse.net/${name}.tar.gz";
    sha256 = "1q9h086v6h3da4b9qyflcjx73cgnqjhb92rv6g4j90m34dndaa3l";
  };

  outputs = [ "out" "dev" ];

  GTEST_DIR = "${gtest.src}/googletest";

  propagatedBuildInputs = [ eigen epoxy ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL2 fftw gtest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = https://movit.sesse.net;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
