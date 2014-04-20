{ cabal, genericDeriving, mtl, reducers, stm, tagged, tasty
, transformers, xml
}:

cabal.mkDerivation (self: {
  pname = "tasty-ant-xml";
  version = "1.0.0.6";
  sha256 = "06ll7mj60iiskla2x53yncs0931b7dw4l0shxkhz88558gjzy7cj";
  buildDepends = [
    genericDeriving mtl reducers stm tagged tasty transformers xml
  ];
  meta = {
    homepage = "http://github.com/ocharles/tasty-ant-xml";
    description = "Render tasty output to XML for Jenkins";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
