{ cabal }:

cabal.mkDerivation (self: {
  pname = "derp";
  version = "0.1.6";
  sha256 = "0g8y98qjjampbwnxhvjzrs2jczh2mcwsacjq95jxpidgsld00shk";
  meta = {
    description = "Derivative Parsing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
