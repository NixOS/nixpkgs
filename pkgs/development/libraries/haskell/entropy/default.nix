{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.2.3";
  sha256 = "04kzl7j73g5ibbc28b4llmnrvhg7q2fji1akx5ii81sfxdpnxy45";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
