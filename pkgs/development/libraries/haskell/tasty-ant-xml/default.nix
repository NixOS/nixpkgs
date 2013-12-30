{ cabal, genericDeriving, mtl, reducers, stm, tagged, tasty
, transformers, xml
}:

cabal.mkDerivation (self: {
  pname = "tasty-ant-xml";
  version = "1.0.0.5";
  sha256 = "00nlp627r5rgahs8zqjxjm68ijf4yvxd18fq67z2fr68alg4rl4j";
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
