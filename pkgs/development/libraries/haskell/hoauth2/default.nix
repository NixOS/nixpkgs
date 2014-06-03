{ cabal, aeson, bytestringShow, conduit, httpConduit, httpTypes
, monadControl, mtl, random, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "hoauth2";
  version = "0.3.7";
  sha256 = "0v43hr7vw2iikhx2bldkb0fa5j95msgn7s7k09vkxz3qwqh9maz7";
  buildDepends = [
    aeson bytestringShow conduit httpConduit httpTypes monadControl mtl
    random resourcet text transformers
  ];
  meta = {
    homepage = "https://github.com/freizl/hoauth2";
    description = "hoauth2";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
