{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "List";
  version = "0.4.4";
  sha256 = "1dmri9l2mzq1kwy2539z9z21a61rr5ldy990kcixngi4wnaymdbz";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/yairchu/generator/tree";
    description = "List monad transformer and class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
