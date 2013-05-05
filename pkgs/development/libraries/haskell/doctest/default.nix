{ cabal, baseCompat, deepseq, filepath, ghcPaths, hspec, HUnit
, QuickCheck, setenv, silently, stringbuilder, syb, transformers
}:

cabal.mkDerivation (self: {
  pname = "doctest";
  version = "0.9.7";
  sha256 = "0d3aywm5v3kx16c1i6cb4inr7hdnmsl8qawxp27g0yng03wdra5l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq filepath ghcPaths syb transformers ];
  testDepends = [
    baseCompat deepseq filepath ghcPaths hspec HUnit QuickCheck setenv
    silently stringbuilder syb transformers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/sol/doctest-haskell#readme";
    description = "Test interactive Haskell examples";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
