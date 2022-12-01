{ lib, stdenv, fetchFromGitHub, python3, cmake, libglvnd, libGLU }:

stdenv.mkDerivation rec {
  pname = "gl3w";
  version = "unstable-2022-03-24";

  src = fetchFromGitHub {
    owner = "skaslev";
    repo = pname;
    rev = "5f8d7fd191ba22ff2b60c1106d7135bb9a335533";
    hash = "sha256-qV/PZmaP5iCHhIzTA2bE4d1RMB6LzRbTsB5gWVvi9bU=";
  };

  nativeBuildInputs = [ python3 cmake ];
  # gl3w installs a CMake config that when included expects to be able to
  # build and link against both of these libraries
  # (the gl3w generated C file gets compiled into the downstream target)
  propagatedBuildInputs = [ libglvnd libGLU ];

  dontUseCmakeBuildDir = true;

  # These files must be copied rather than linked since they are considered
  # outputs for the custom command, and CMake expects to be able to touch them
  preConfigure = ''
    mkdir -p include/{GL,KHR}
    cp ${libglvnd.dev}/include/GL/glcorearb.h include/GL/glcorearb.h
    cp ${libglvnd.dev}/include/KHR/khrplatform.h include/KHR/khrplatform.h
  '';

  meta = with lib; {
    description = "Simple OpenGL core profile loading";
    homepage = "https://github.com/skaslev/gl3w";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.unix;
  };
}
