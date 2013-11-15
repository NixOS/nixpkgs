{ cabal, genericDeriving, mtl, reducers, stm, tagged, tasty
, transformers, xml
}:

cabal.mkDerivation (self: {
  pname = "tasty-ant-xml";
  version = "1.0.0.1";
  sha256 = "1yn337dr9clzrkr8kpvm7x07lyb3v8pcijrddqah08k0ds8zpzcj";
  buildDepends = [
    genericDeriving mtl reducers stm tagged tasty transformers xml
  ];
  meta = {
    homepage = "http://github.com/ocharles/tasty-ant-xml";
    description = "A tasty ingredient to output test results in XML, using the Ant schema. This XML can be consumed by the Jenkins continuous integration framework.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
