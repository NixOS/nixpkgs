{ cabal, alex }:

cabal.mkDerivation (self: {
  pname = "bytestring-lexing";
  version = "0.3.0";
  sha256 = "1jrhmljy7m84imcmvsarv74i3hcm60ja9pl1ww3lm0zgi0rrddqd";
  buildTools = [ alex ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Parse literals efficiently from strict or lazy bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
