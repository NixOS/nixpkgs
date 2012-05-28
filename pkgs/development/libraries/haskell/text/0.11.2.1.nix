{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.2.1";
  sha256 = "0ajh2xhf8khh5vi4crdjgcs7w27dga7hlwzi8ia5xjs3hzgvbjb9";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
