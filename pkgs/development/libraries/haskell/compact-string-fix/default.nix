{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "compact-string-fix";
  version = "0.3.2";
  sha256 = "161z0lmrrqvy77ppdgz7m6nazcmlmy1azxa8rx0cgpqmyxzkf87n";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://twan.home.fmf.nl/compact-string/";
    description = "Same as compact-string except with a small fix so it builds on ghc-6.12";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
