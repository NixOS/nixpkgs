{ cabal, aeson, bytestringShow, httpConduit, httpTypes
, monadControl, mtl, random, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "hoauth2";
  version = "0.4.0";
  sha256 = "1499rgcn3h4921x21s6l0spnjf3wvmsaa07pimgjgb4rjib3z2d5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson bytestringShow httpConduit httpTypes monadControl mtl random
    text transformers
  ];
  meta = {
    homepage = "https://github.com/freizl/hoauth2";
    description = "hoauth2";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
