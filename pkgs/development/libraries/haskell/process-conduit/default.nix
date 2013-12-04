{ cabal, conduit, controlMonadLoop, hspec, mtl, shakespeareText
, text
}:

cabal.mkDerivation (self: {
  pname = "process-conduit";
  version = "1.0.0.1";
  sha256 = "1b1bya316gxj3rgn7qpjmmcllgy9aac69rqw664sw1rnypnic780";
  buildDepends = [
    conduit controlMonadLoop mtl shakespeareText text
  ];
  testDepends = [ conduit hspec ];
  meta = {
    homepage = "http://github.com/tanakh/process-conduit";
    description = "Conduits for processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
