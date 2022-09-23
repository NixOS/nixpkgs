{ fetchFromGitHub, lib, stdenv, ant, jdk }:

stdenv.mkDerivation {
  pname = "hydra-ant-logger";
  version = "2010.2";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra-ant-logger";
    rev = "dae3224f4ed42418d3492bdf5bee4f825819006f";
    sha256 = "sha256-5oQ/jZfz7izTcYR+N801HYh4lH2MF54PCMnmA4CpRwc=";
  };

  buildInputs = [ ant jdk ];

  buildPhase = "mkdir lib; ant";

  installPhase = ''
    mkdir -p $out/share/java
    cp -v *.jar $out/share/java
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
