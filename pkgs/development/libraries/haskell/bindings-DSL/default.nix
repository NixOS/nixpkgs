{ cabal }:

cabal.mkDerivation (self: {
  pname = "bindings-DSL";
  version = "1.0.17";
  sha256 = "1203n6wzdp21hd7zdhvhppxhkz4xr3qykwkb8j5mb2s4kijx01bn";
  meta = {
    homepage = "http://bitbucket.org/mauricio/bindings-dsl";
    description = "FFI domain specific language, on top of hsc2hs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
