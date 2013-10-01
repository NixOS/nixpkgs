{ cabal, Cabal, fgl, filepath, parsec, text }:

cabal.mkDerivation (self: {
  pname = "cabal-macosx";
  version = "0.2.3";
  sha256 = "0rvmb6lx2alr7f0v7nbv48xzg7wp4nrn03hdkjc4a4c97rai14i9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal fgl filepath parsec text ];
  meta = {
    homepage = "http://github.com/gimbo/cabal-macosx";
    description = "Cabal support for creating Mac OSX application bundles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
