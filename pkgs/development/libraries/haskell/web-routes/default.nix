{ cabal, blazeBuilder, httpTypes, mtl, network, parsec, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.26.3";
  sha256 = "1ldi4gjraga57qj9drknwp19vmy30fhcp6vw3y7xqcrarvp5n2mx";
  buildDepends = [
    blazeBuilder httpTypes mtl network parsec text utf8String
  ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
