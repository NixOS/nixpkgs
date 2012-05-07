{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "abstract-par";
  version = "0.3";
  sha256 = "1accd14hkpcvlfiv85swliyyrw9xm1dbkyn4vn2p5nf1h6js67xw";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "Type classes generalizing the functionality of the 'monad-par' library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
