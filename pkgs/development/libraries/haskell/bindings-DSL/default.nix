{ cabal }:

cabal.mkDerivation (self: {
  pname = "bindings-DSL";
  version = "1.0.20";
  sha256 = "11qc02fkmrpy6c1a85lwlz06m4fpvfpbpbxgv5rkyb1amg2cnklq";
  meta = {
    homepage = "http://bitbucket.org/mauricio/bindings-dsl";
    description = "FFI domain specific language, on top of hsc2hs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
