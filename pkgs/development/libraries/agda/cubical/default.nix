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

<<<<<<< HEAD
  meta = {
    description = "Cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      alexarice
      ryanorendorff
      ncfavier
      phijor
    ];
  };
}
