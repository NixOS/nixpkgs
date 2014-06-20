{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.6.4.1";
  sha256 = "03fwpl8hrl9q197w8v1glqi5g1d51c7hz4m8zi5s8x1yvpbwcfvl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
