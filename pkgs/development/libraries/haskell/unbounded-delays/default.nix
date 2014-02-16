{ cabal }:

cabal.mkDerivation (self: {
  pname = "unbounded-delays";
  version = "0.1.0.6";
  sha256 = "0yykb9jqxhvbngvp2gbzb0ch2cmzdxx8km62dclyvr3xbv6hk1h7";
  meta = {
    homepage = "https://github.com/basvandijk/unbounded-delays";
    description = "Unbounded thread delays and timeouts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
