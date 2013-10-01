{ cabal }:

cabal.mkDerivation (self: {
  pname = "cereal";
  version = "0.4.0.0";
  sha256 = "0q6lrfa2p70mh3d08mbj89anc3p9ycy6wyyiycj5pm62kcimv7rj";
  meta = {
    description = "A binary serialization library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
