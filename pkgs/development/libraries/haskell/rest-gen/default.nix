{ cabal, aeson, blazeHtml, Cabal, codeBuilder, fclabels, filepath
, hashable, haskellSrcExts, hslogger, HStringTemplate, HUnit, hxt
, jsonSchema, restCore, safe, scientific, split, tagged
, testFramework, testFrameworkHunit, text, uniplate
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "rest-gen";
  version = "0.14.1";
  sha256 = "0skpj4y4v9q7brcq54wgl4kyxa1bqqw7gzb1r98d4ml0j3vhjn19";
  buildDepends = [
    aeson blazeHtml Cabal codeBuilder fclabels filepath hashable
    haskellSrcExts hslogger HStringTemplate hxt jsonSchema restCore
    safe scientific split tagged text uniplate unorderedContainers
    vector
  ];
  testDepends = [
    haskellSrcExts HUnit restCore testFramework testFrameworkHunit
  ];
  meta = {
    description = "Documentation and client generation from rest definition";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
