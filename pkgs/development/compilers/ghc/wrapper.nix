{stdenv, ghc}:

stdenv.mkDerivation {
  name = "ghc-wrapper-${ghc.version}";

  propagatedBuildInputs = [ghc];

  unpackPhase = "true";
  installPhase = "true";
  
  setupHook = ./setup-hook.sh;

  inherit ghc;
  ghcVersion = ghc.version;
}
