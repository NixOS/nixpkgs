{ cabal }:

cabal.mkDerivation (self: {
  pname = "bindings-DSL";
  version = "1.0.19";
  sha256 = "0mjlv2ld1qdd83pv7khrk3f0g4ypk8a8z79ykp3nwbvlhhi7bp2h";
  meta = {
    homepage = "http://bitbucket.org/mauricio/bindings-dsl";
    description = "FFI domain specific language, on top of hsc2hs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
