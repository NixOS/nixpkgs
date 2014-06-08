{ cabal, attoparsec, caseInsensitive, hashable, network, snap, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snap-cors";
  version = "1.2.4";
  sha256 = "0mg5sjvrcs60s8k28vgi49vbgfpswkcd7i7yyfi1n1649vqb69mb";
  buildDepends = [
    attoparsec caseInsensitive hashable network snap text transformers
    unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ocharles/snap-cors";
    description = "Add CORS headers to Snap applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
