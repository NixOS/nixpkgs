{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "thespian";
  version = "0.999";
  sha256 = "0z3cqjcf6xr0z7g3s1jszcs39w43sl0793gl0qm3dklbginqbcnn";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://bitbucket.org/alinabi/thespian";
    description = "Lightweight Erlang-style actors for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
