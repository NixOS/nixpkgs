{ lib
, stdenv
, fetchFromGitHub
, cmake
, blas
, lapack
}:


stdenv.mkDerivation rec {
  pname = "hmat-oss";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    rev = "refs/tags/${version}";
    sha256 = "sha256-Xc8AbeyEtM6R5I4HdgF4XR5/b8ZYBOv34kY1xrYk/Jw=";
  };

  cmakeFlags = [
    "-DHMAT_GIT_VERSION=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas lapack ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gdinh ];
  };
}
