{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.1.2.3";
  sha256 = "19v94b34c2j6f9d9xii2hg0mjxdkq51aifkcqw6hbicn97kfcxls";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
