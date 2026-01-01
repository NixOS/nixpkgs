{
  lib,
  mkDerivation,
  haskellPackages,
}:

mkDerivation {
  pname = "agda2hs-base";

  inherit (haskellPackages.agda2hs) src version;

  postUnpack = ''
    sourceRoot="$sourceRoot/lib/base"
  '';

  libraryFile = "base.agda-lib";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/agda/agda2hs";
    description = "Standard library for compiling Agda code to readable Haskell";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      wrvsrx
    ];
  };
}
