{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  libglvnd,
  libGLU,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gl3w";
  version = "0-unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "skaslev";
    repo = pname;
    rev = "3a33275633ce4be433332dc776e6a5b3bdea6506";
    hash = "sha256-kEm5QItpasSFJQ32YBHPpc+itz/nQ8bQMCavbOTGT/w=";
  };

  nativeBuildInputs = [
    python3
    cmake
  ];
  # gl3w installs a CMake config that when included expects to be able to
  # build and link against both of these libraries
  # (the gl3w generated C file gets compiled into the downstream target)
  propagatedBuildInputs = [
    libglvnd
    libGLU
  ];

  dontUseCmakeBuildDir = true;

  # These files must be copied rather than linked since they are considered
  # outputs for the custom command, and CMake expects to be able to touch them
  preConfigure = ''
    mkdir -p include/{GL,KHR}
    cp ${libglvnd.dev}/include/GL/glcorearb.h include/GL/glcorearb.h
    cp ${libglvnd.dev}/include/KHR/khrplatform.h include/KHR/khrplatform.h
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Simple OpenGL core profile loading";
    homepage = "https://github.com/skaslev/gl3w";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.unix;
  };
}
