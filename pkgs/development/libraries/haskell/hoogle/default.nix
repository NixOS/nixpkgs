{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, random, safe, tagsoup, text, time, transformers, uniplate
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.24";
  sha256 = "01q0pr82wscnrm7flb1sd9fv8sym1pkdfvdmp6qcfwzzvrcsh5h2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec random safe
    tagsoup text time transformers uniplate wai warp
  ];
  testDepends = [ filepath ];
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
