{ lib
, stdenv
, fetchFromGitHub
, unzip
, cmake
, freeglut
, libGLU
, libGL
, zlib
, swig
, doxygen
, xorg
, python3
, darwin
}:

stdenv.mkDerivation rec {
  pname = "partio";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "refs/tags/v${version}";
    hash = "sha256-3t3y3r4R/ePw2QE747rqumbrYRm1wNkSKN3n8MPPIVg=";
  };

  outputs = [ "dev" "out" "lib" ];

  nativeBuildInputs = [
    unzip
    cmake
    doxygen
  ];

  buildInputs = [
    zlib
    swig
    xorg.libXi
    xorg.libXmu
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.GLUT
  ] ++ lib.optionals (!stdenv.isDarwin) [
    freeglut
    libGLU
    libGL
  ];

  # TODO:
  # Sexpr support

  strictDeps = true;

  meta = with lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://github.com/wdas/partio";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.guibou ];
  };
}
