{ lib
, stdenv
, fetchFromGitHub
, unzip
, cmake
, libglut
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
  version = "1.17.3";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "refs/tags/v${version}";
    hash = "sha256-wV9byR85qwOkoTyLjG0gOLC3Gc19ykwiLpDy4T/MENQ=";
  };

  outputs = [ "dev" "out" "lib" ];

  nativeBuildInputs = [
    unzip
    cmake
    doxygen
    python3
  ];

  buildInputs = [
    zlib
    swig
    xorg.libXi
    xorg.libXmu
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.GLUT
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libglut
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
