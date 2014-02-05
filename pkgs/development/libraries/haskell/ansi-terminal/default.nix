{ cabal }:

cabal.mkDerivation (self: {
  pname = "ansi-terminal";
  version = "0.6.1.1";
  sha256 = "06pdcpp2z7wk9mkr5lzwk64lqhj09c7l1ah4s3vz7zwrdzfaccwi";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "https://github.com/feuerbach/ansi-terminal";
    description = "Simple ANSI terminal support, with Windows compatibility";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
