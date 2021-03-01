{ lib
, stdenv
, buildPackages
, fetchFromGitHub
, zlib
, ilmbase
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.5.3";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "xyYdRrwAYdnRZmErIK0tZspguqtrXvixO5+6nMDoOh8=";
  };

  patches = [
    # Fix pkg-config paths
    (fetchpatch {
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/6442fb71a86c09fb0a8118b6dbd93bcec4883a3c.patch";
      sha256 = "bwD5WTKPT4DjOJDnPXIvT5hJJkH0b71Vo7qupWO9nPA=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ ilmbase zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
