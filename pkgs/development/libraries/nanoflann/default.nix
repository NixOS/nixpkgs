{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.4.3";
  pname = "nanoflann";

  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "sha256-NcewcNQcI1CjMNibRF9HCoE2Ibs0/Hy4eOkJ20W3wLo=";
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
