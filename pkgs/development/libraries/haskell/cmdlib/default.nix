{ cabal, mtl, split, syb }:

cabal.mkDerivation (self: {
  pname = "cmdlib";
  version = "0.3.2.1";
  sha256 = "0p8jpwngc8nbpl6v0i8hqhm1nsm2c51pswi6nym6dkwkilaxbvs4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl split syb ];
  meta = {
    description = "a library for command line parsing & online help";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
