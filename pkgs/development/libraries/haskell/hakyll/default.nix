{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, dataDefault, deepseq, filepath, httpConduit
, httpTypes, HUnit, lrucache, mtl, pandoc, parsec, QuickCheck
, random, regexBase, regexTdfa, snapCore, snapServer, tagsoup
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.2.2.0";
  sha256 = "0kz8v2ip0hmvqnrxgv44g2863z1dql88razl7aa3fw01q56ihz0y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath httpConduit httpTypes lrucache mtl
    pandoc parsec random regexBase regexTdfa snapCore snapServer
    tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath httpConduit httpTypes HUnit lrucache
    mtl pandoc parsec QuickCheck random regexBase regexTdfa snapCore
    snapServer tagsoup testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  patchPhase = ''
    sed -i -e 's|cryptohash .*,|cryptohash,|' hakyll.cabal
  '';
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
