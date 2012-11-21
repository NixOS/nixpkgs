{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.2";
  sha256 = "1c8drabfmx5wc519kxsr64bdvakfvxwzhfh7ym01kk1dpja0nlnq";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
