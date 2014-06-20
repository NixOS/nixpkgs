{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "data-lens-light";
  version = "0.1.2";
  sha256 = "1xxphcd36vw1ib48rfmrg207h0i1hlby01bm3xsxnq90ygizvxk7";
  buildDepends = [ mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/data-lens-light";
    description = "Simple lenses, minimum dependencies";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
