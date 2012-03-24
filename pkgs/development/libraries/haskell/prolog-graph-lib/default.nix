{ cabal, fgl, graphviz, mtl, prolog, text }:

cabal.mkDerivation (self: {
  pname = "prolog-graph-lib";
  version = "0.1";
  sha256 = "1gryhk0jd8bvmjbjkz6n7sfnsa6iwzkckpgi51xsj5f2nwdxbl6g";
  buildDepends = [ fgl graphviz mtl prolog text ];
  meta = {
    homepage = "https://github.com/Erdwolf/prolog";
    description = "Generating images of resolution trees for Prolog queries";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
