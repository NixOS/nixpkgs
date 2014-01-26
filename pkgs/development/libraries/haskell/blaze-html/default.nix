{ cabal, blazeBuilder, blazeMarkup, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.7.0.0";
  sha256 = "1k8mxq3hmf2s7qab67jz3yaan7wdc4mn5sa00rw5zk4mjh722w86";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  testDepends = [
    blazeBuilder blazeMarkup HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text
  ];
  patchPhase = ''
    sed -i -e 's|blaze-markup.*>=.*,|blaze-markup,|' blaze-html.cabal
  '';
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
