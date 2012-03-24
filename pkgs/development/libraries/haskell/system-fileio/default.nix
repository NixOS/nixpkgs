{ cabal, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.7";
  sha256 = "0vjjpn3fq0s2assfg3p3wpk60jsrjp1f6i0djm3abdbmc53gqyi0";
  buildDepends = [ systemFilepath text time ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "Consistent filesystem interaction across GHC versions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
