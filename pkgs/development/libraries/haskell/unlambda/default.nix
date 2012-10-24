{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "unlambda";
  version = "0.1.2";
  sha256 = "12x7jc5nwbhkhnylg9l29nr5y8p322avhb9zc0w2apy3fvrq7y93";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  meta = {
    description = "Unlambda interpreter";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
