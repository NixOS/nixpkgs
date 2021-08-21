{ lib
, stdenv
, fetchFromGitHub
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.0.5";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "0inmpby1syyxxzr0sazqvpb8j63vpj09vpkp4xi7m2qd4rxynkph";
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
