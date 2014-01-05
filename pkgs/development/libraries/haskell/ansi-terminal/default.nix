{ cabal }:

cabal.mkDerivation (self: {
  pname = "ansi-terminal";
  version = "0.6.1";
  sha256 = "0ncghc0z2xkfn1hfvyl0haf4mia9lhjbiqda11nxkqqfxdyklb2j";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "https://github.com/feuerbach/ansi-terminal";
    description = "Simple ANSI terminal support, with Windows compatibility";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
