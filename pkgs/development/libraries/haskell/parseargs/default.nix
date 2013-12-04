{ cabal }:

cabal.mkDerivation (self: {
  pname = "parseargs";
  version = "0.1.5.2";
  sha256 = "0pzw7w1kr2rv6ffqgn93rypn37wy2r5k01p3y5256laaplm575am";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/BartMassey/parseargs";
    description = "Command-line argument parsing library for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
