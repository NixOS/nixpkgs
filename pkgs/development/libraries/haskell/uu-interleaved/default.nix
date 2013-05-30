{ cabal }:

cabal.mkDerivation (self: {
  pname = "uu-interleaved";
  version = "0.1.0.0";
  sha256 = "00zq89fjz3r5pj6qbci017cm9y2rsvl265y9d95q0rv6ljhsayzs";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Providing an interleaving combinator for use with applicative/alternative style implementations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
