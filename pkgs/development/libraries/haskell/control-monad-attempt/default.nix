{cabal, attempt, transformers} :

cabal.mkDerivation (self : {
  pname = "control-monad-attempt";
  version = "0.3.0";
  sha256 = "1l0bqb5h2fs7vx2r8nd6kscyyrrqc0gshnxwdz9p6clfnknyqbqw";
  propagatedBuildInputs = [ attempt transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/control-monad-attempt";
    description = "Monad transformer for attempt.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
