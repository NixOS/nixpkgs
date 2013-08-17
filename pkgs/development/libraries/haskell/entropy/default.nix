{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.2.2";
  sha256 = "1xkpfi6njj5iqwn5wa6npyzxksj9hr0xqbxrslg646whxrkd8718";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
