{ cabal, ranges, text, textIcu }:

cabal.mkDerivation (self: {
  pname = "stringprep";
  version = "0.1.5";
  sha256 = "1a25b18kd1zx06gi677g3xvsm49izhhf26z2dfljkjfykf05kqmp";
  buildDepends = [ ranges text textIcu ];
  meta = {
    description = "Implements the \"StringPrep\" algorithm";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
