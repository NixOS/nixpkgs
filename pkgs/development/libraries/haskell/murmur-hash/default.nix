{ cabal }:

cabal.mkDerivation (self: {
  pname = "murmur-hash";
  version = "0.1.0.6";
  sha256 = "0wnkwl3a9x0f4rvsj4wf129n03vpw8qk4kzx6vmrapwwb4r80npz";
  meta = {
    homepage = "http://github.com/nominolo/murmur-hash";
    description = "MurmurHash2 implementation for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
