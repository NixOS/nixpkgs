{ lib
, stdenv
, buildPackages
, fetchFromGitHub
, zlib
, ilmbase
, fetchpatch 
, cmake
, libtool
}:
stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "020gyl8zv83ag6gbcchmqiyx9rh2jca7j8n52zx1gk4rck7kwc01";
  };

  outputs = [ "bin" "dev" "out" "doc" ];
  nativeBuildInputs = [ cmake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
