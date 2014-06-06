{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "pattern-arrows";
  version = "0.0.2";
  sha256 = "13q7bj19hd60rnjfc05wxlyck8llxy11z3mns8kxg197wxrdkhkg";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://blog.functorial.com/posts/2013-10-27-Pretty-Printing-Arrows.html";
    description = "Arrows for Pretty Printing";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
