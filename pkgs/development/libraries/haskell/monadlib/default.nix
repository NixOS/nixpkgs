{ cabal }:

cabal.mkDerivation (self: {
  pname = "monadLib";
  version = "3.7.2";
  sha256 = "01s7jfwzr4jmwz1k4bkxi38q8v364vg6fnn77n5v8zpbimcv3rds";
  meta = {
    homepage = "http://wiki.github.com/yav/monadlib";
    description = "A collection of monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.thoughtpolice ];
  };
})
