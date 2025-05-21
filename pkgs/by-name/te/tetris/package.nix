{
  haskellPackages,
  haskell,
}:

haskell.lib.compose.justStaticExecutables (
  haskellPackages.callPackage (
    {
      mkDerivation,
      fetchFromGitHub,
      lib,

      base,
      vty,
      lens,
      brick,
      linear,
      containers,
      random,
      transformers,
      directory,
      filepath,
      optparse-applicative,
      vty-crossplatform,
      mtl,
      extra,
    }:
    mkDerivation rec {
      pname = "tetris";
      version = "0.1.6";
      src = fetchFromGitHub {
        repo = "tetris";
        owner = "Samtay";
        tag = "v${version}";
        hash = "sha256-xA2/n5zY01BLKlUI8BVvfuUvsqh2U23XOooTQwXkDpQ=";
      };
      libraryHaskellDepends = [
        base
        brick
        containers
        extra
        lens
        linear
        mtl
        random
        transformers
        vty
        vty-crossplatform
      ];
      executableHaskellDepends = [
        base
        directory
        filepath
        optparse-applicative
      ];
      homepage = "https://github.com/samtay/tetris";
      changelog = "https://github.com/samtay/tetris/releases/tag/v${version}";
      license = lib.licenses.bsd3;
      mainProgram = "tetris";
      maintainers = [ lib.maintainers.Svenum ];
    }
  ) { }
)
