{ lib
, stdenv
, fetchFromGitHub
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.1.3";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "sha256-Bi6yTcZBWTsWWMm3A7FVYblvSXKLSkHmhGvpNYGiOzE=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ imath zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
