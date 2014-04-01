{ cabal, conduit, controlMonadLoop, hspec, mtl, shakespeare
, shakespeareText, text
}:

cabal.mkDerivation (self: {
  pname = "process-conduit";
  version = "1.0.0.2";
  sha256 = "0rz18x7gy8w1h2xq0il49k515n0y3gpxnl7mfgkczc86965w7fzj";
  buildDepends = [
    conduit controlMonadLoop mtl shakespeare shakespeareText text
  ];
  testDepends = [ conduit hspec ];
  meta = {
    homepage = "http://github.com/tanakh/process-conduit";
    description = "Conduits for processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
