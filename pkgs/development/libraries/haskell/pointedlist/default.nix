{ cabal, binary, derive }:

cabal.mkDerivation (self: {
  pname = "pointedlist";
  version = "0.6";
  sha256 = "16sfw77w46f7rjd1lpdfzi1bdgf81siy2sj71xqkqbsz6cvkjakg";
  buildDepends = [ binary derive ];
  meta = {
    description = "A zipper-like comonad which works as a list, tracking a position";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
