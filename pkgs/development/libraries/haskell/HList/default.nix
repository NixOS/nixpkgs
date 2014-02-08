{ cabal, cmdargs, diffutils, doctest, filepath, hspec, lens, mtl
, syb
}:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.3.2.0";
  sha256 = "1cv27y8jg38yvfca83zn3fzq7mkzhqw7j1y7kg5fkfh4wd8ixs1f";
  buildDepends = [ mtl ];
  testDepends = [ cmdargs doctest filepath hspec lens mtl syb ];
  buildTools = [ diffutils ];
  doCheck = false;
  meta = {
    description = "Heterogeneous lists";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
