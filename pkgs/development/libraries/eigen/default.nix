{stdenv, fetchurl, fetchpatch, cmake}:

let
  version = "3.3.5";
in
stdenv.mkDerivation {
  name = "eigen-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "13p60x6k61zq2y2in7g4fy5p55cr5dbmj3zvw10zcazxraxbcm04";
  };

  patches = [
    ./include-dir.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    inherit version;
  };
}
