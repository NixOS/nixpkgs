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
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "04ga72h8fha4z31vmwyb21i7xzncn13fzr54b73rcfkb4b017s4v";
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
