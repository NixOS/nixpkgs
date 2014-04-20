{ cabal, aeson, bytestringShow, conduit, httpConduit, httpTypes
, monadControl, mtl, random, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "hoauth2";
  version = "0.3.6.1";
  sha256 = "0nfh77fxyl8vbdnrrp28hsl1zhxhmg8mjn0gfvc2i3w5rd6j0lda";
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
