{ cabal, icu, text }:

cabal.mkDerivation (self: {
  pname = "text-icu";
  version = "0.6.3.5";
  sha256 = "1blfw9377yl732ypbjhkvi3vfg6c1f1rkxcsvwmqyhkdzb2agg0a";
  buildDepends = [ text ];
  extraLibraries = [ icu ];
  meta = {
    homepage = "https://bitbucket.org/bos/text-icu";
    description = "Bindings to the ICU library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
