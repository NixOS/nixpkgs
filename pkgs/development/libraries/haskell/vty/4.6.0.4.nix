{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String }:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.6.0.4";
  sha256 = "0kabssw3v7nglvsr687ppmdnnmii1q2g5zg8rxwi2hcmvnjx7567";
  buildDepends = [ deepseq mtl parallel parsec terminfo utf8String ];
  meta = {
    homepage = "http://trac.haskell.org/vty/";
    description = "A simple terminal access library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
