{ cabal, deepseq, extensibleExceptions, List, text, transformers
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hexpat";
  version = "0.20.3";
  sha256 = "13dh0cvcmp6yi4nncsn6q9pkisld9xvz6j4xabng5ax67vdgdvrs";
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
