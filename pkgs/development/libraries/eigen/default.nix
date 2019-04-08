{stdenv, fetchurl, fetchpatch, cmake}:

let
  version = "3.3.7";
in
stdenv.mkDerivation {
  name = "eigen-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "1nnh0v82a5xibcjaph51mx06mxbllk77fvihnd5ba0kpl23yz13y";
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
