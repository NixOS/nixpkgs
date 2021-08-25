{ lib
, stdenv
, fetchFromGitHub
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.1.1";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "1p0l07vfpb25fx6jcgk1747v8x9xgpifx4cvvgi3g2473wlx6pyb";
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
