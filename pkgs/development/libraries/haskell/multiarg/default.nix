{ cabal, explicitException, QuickCheck, text, transformers
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.1.0.0";
  sha256 = "010mph49fq0rdr5dmm4pdlbmfmaaas8wffa9p1cgprs2ic1hnx3g";
  buildDepends = [
    explicitException QuickCheck text transformers utf8String
  ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
