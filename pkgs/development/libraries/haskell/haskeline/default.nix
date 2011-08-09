{ cabal, extensibleExceptions, mtl, terminfo, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.0";
  sha256 = "0p2qbckvdhzid6zrcgjwr8b5h8vxd7wdswsm2qp3hiyg48v4y5hd";
  buildDepends = [ extensibleExceptions mtl terminfo utf8String ];
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
