{ cabal, monadControl, transformers }:

cabal.mkDerivation (self: {
  pname = "pool";
  version = "0.1.2.1";
  sha256 = "1fwwnwxk3kprr2z9y7bwa1qwxfkzwcb2n5l6vkq1c5s8gjls581c";
  buildDepends = [ monadControl transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Thread-safe resource pools. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
