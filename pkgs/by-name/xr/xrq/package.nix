{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
}:

stdenv.mkDerivation {
  pname = "xrq";
  version = "0-unstable-2016-01-15";

  src = fetchFromGitHub {
    owner = "arianon";
    repo = "xrq";
    rev = "d5dc19c63881ebdd1287a02968e3a1447dde14a9";
    hash = "sha256-ZlzYxgu0A7cxRcg/G/wQhCYh7qlIgPNVlnNw6QY0rq8=";
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ libx11 ];

  meta = {
    description = "X utility for querying xrdb";
    homepage = "https://github.com/arianon/xrq";
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
    mainProgram = "xrq";
  };
}
