{cabal, haskellSrcExts, mtl, uniplate}:

cabal.mkDerivation (self : {
  pname = "derive";
  version = "2.3.0.2";
  sha256 = "bb8f62d93742d0f27c742bf09fdad73111057d9b531dda45d7f0c894b447809e";
  propagatedBuildInputs = [haskellSrcExts mtl uniplate];
  meta = {
    description = "A program and library to derive instances for data types";
  };
})
