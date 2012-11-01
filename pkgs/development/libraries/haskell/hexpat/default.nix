{ cabal, deepseq, extensibleExceptions, List, text, transformers
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hexpat";
  version = "0.20.2";
  sha256 = "1v96xiys1664cdspbd9mps9m1ia4xwykzsg4z62pklqnf21wna7j";
  buildDepends = [
    deepseq extensibleExceptions List text transformers utf8String
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Hexpat/";
    description = "XML parser/formatter based on expat";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
