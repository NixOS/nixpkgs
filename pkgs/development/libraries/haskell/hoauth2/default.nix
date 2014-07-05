{ cabal, aeson, bytestringShow, httpConduit, httpTypes
, monadControl, mtl, random, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "hoauth2";
  version = "0.4.1";
  sha256 = "145lgy9bxx1xdljbkvi6s97n2z1k5fd0idp415r71ydw8h3i8ppx";
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
