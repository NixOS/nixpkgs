{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-ordlist";
  version = "0.4.6";
  sha256 = "13gsvqifwlxcz10x704fy26288l0km2kfdlh4w9hl31a9vd427sx";
  meta = {
    description = "Set and bag operations on ordered lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
