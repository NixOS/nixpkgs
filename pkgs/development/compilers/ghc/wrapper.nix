{stdenv, ghc}:

stdenv.mkDerivation {
  name = "${ghc.name}-wrapper";

  propagatedBuildInputs = [ghc];

  unpackPhase = "true";
  installPhase = "true";
  
  setupHook = ./setup-hook.sh;

  inherit ghc;
}
