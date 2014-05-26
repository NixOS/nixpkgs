{ cabal, genericDeriving, mtl, reducers, stm, tagged, tasty
, transformers, xml
}:

cabal.mkDerivation (self: {
  pname = "tasty-ant-xml";
  version = "1.0.0.7";
  sha256 = "0jjh2lyr33l5mps123azszwnk0h61ar99zlqbc4h04a8vkd9x813";
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
