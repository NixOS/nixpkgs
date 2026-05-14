{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "cubical";
  version = "0.9";

  src = fetchFromGitHub {
    repo = "cubical";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-Lmzofq2rKFmfsAoH3zIFB2QLeUhFmIO44JsF+dDrubw=";
  };

  meta = {
    description = "Cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alexarice
      ryanorendorff
      ncfavier
      phijor
    ];
  };
}
