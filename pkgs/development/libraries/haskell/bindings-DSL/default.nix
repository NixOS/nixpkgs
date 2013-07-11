{ cabal }:

cabal.mkDerivation (self: {
  pname = "bindings-DSL";
  version = "1.0.16";
  sha256 = "1sly88585f94dsnhyw6nagnr4jfjixnn61my85x05987flf325px";
  meta = {
    homepage = "http://bitbucket.org/mauricio/bindings-dsl";
    description = "FFI domain specific language, on top of hsc2hs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
