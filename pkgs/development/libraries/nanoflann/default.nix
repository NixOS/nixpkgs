{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "nanoflann";

  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "sha256-vPLL6l4sFRi7nvIfdMbBn/gvQ1+1lQHlZbR/2ok0Iw8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/jlblancoc/nanoflann";
    license = lib.licenses.bsd2;
    description = "Header only C++ library for approximate nearest neighbor search";
    platforms = lib.platforms.unix;
  };
}
