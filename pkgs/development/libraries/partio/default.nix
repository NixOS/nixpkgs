<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, unzip, cmake, freeglut, libGLU, libGL, zlib, swig, doxygen, xorg, python3 }:

stdenv.mkDerivation rec {
  pname = "partio";
  version = "1.14.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-3t3y3r4R/ePw2QE747rqumbrYRm1wNkSKN3n8MPPIVg=";
=======
    hash = "sha256-S8U5I3dllFzDSocU1mJ8FYCCmBpsOR4n174oiX5hvAM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "dev" "out" "lib" ];

<<<<<<< HEAD
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
=======
  nativeBuildInputs = [ unzip cmake doxygen ];
  buildInputs = [ freeglut libGLU libGL zlib swig xorg.libXi xorg.libXmu python3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # TODO:
  # Sexpr support

  strictDeps = true;

  meta = with lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
<<<<<<< HEAD
    homepage = "https://github.com/wdas/partio";
    license = licenses.bsd3;
    platforms = platforms.unix;
=======
    homepage = "https://www.disneyanimation.com/technology/partio.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.guibou ];
  };
}
