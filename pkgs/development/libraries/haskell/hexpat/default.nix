{ cabal, deepseq, List, text, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "hexpat";
  version = "0.20.4";
  sha256 = "09ixvwgrr1046v806d23ngdhc8xqkf0yadzlbwxcy228ka13xwdw";
  buildDepends = [ deepseq List text transformers utf8String ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Hexpat/";
    description = "XML parser/formatter based on expat";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
