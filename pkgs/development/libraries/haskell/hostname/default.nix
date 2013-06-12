{ cabal }:

cabal.mkDerivation (self: {
  pname = "hostname";
  version = "1.0";
  sha256 = "0p6gm4328946qxc295zb6vhwhf07l1fma82vd0siylnsnsqxlhwv";
  meta = {
    description = "A very simple package providing a cross-platform means of determining the hostname";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
