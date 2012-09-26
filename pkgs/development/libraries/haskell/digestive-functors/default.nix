{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.5.0.2";
  sha256 = "1phakcljl6ri2p9lfzjnn001jw0inyxa5zd7lp2k9lhq1yq0byb0";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
