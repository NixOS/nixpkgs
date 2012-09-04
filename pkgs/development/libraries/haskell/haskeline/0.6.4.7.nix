{ cabal, extensibleExceptions, filepath, mtl, terminfo, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.7";
  sha256 = "18ma4i2i6hx8bhbkh1d7mqzsqbfj0zc2bkv3czjyylizqwhpq6ih";
  buildDepends = [
    extensibleExceptions filepath mtl terminfo utf8String
  ];
  configureFlags = "-fterminfo";
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
