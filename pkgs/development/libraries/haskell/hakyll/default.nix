{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, deepseq, filepath, httpConduit, httpTypes, lrucache
, mtl, pandoc, parsec, random, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.1.2.0";
  sha256 = "1kbilad4ry8lyfcygajaphkgragmq5js349mjmh1bjn04rhjm54c";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash deepseq
    filepath httpConduit httpTypes lrucache mtl pandoc parsec random
    regexBase regexTdfa snapCore snapServer tagsoup text time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
