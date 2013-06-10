{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.2.1";
  sha256 = "1yl1gmkmbalm27pjlpm9nhsbxpvxl8w7p8psq5apyrbdqnv9yhbg";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
