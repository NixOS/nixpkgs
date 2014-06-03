{ cabal, genericDeriving, mtl, reducers, stm, tagged, tasty
, transformers, xml
}:

cabal.mkDerivation (self: {
  pname = "tasty-ant-xml";
  version = "1.0.0.8";
  sha256 = "0khjx3anxp63ch6wkdhqnsk5miavkq014ab30rpir97gdqw0vykm";
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
