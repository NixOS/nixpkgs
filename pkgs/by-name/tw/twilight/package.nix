{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  libglut,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "twilight";
  version = "unstable-2018-04-19";

  src = fetchFromGitHub {
    owner = "tweakoz";
    repo = "twilight";
    rev = "43f21d15c2a8923c9d707bdf3789f480bfd4b36d";
    hash = "sha256-/5IazIAXZKpcG6PG/75mXmqBjrKlTwOV5ah5JCWJtVY=";
  };

  buildInputs = [
    libGL
    libGLU
    libglut
    libx11
  ];

  installPhase = ''
    install -Dm755 twilight $out/bin/twilight
  '';

  meta = {
    description = "Redo of IRIX twilight backdrop in old school OpenGL";
    homepage = src.meta.homepage;
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "twilight";
  };
}
