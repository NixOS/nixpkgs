{ cabal, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "string-conversions";
  version = "0.3.0.2";
  sha256 = "0jcm0vv0ll74zfc7s2l8qpqpbfnkv7ir9d1kg68m6b0f9sq0dgng";
  buildDepends = [ text utf8String ];
  meta = {
    description = "Simplifies dealing with different types for strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
