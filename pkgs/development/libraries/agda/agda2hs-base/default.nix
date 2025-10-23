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

  meta = with lib; {
    homepage = "https://github.com/agda/agda2hs";
    description = "Standard library for compiling Agda code to readable Haskell";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      wrvsrx
    ];
  };
}
