{ cabal }:

cabal.mkDerivation (self: {
  pname = "timerep";
  version = "1.0.3";
  sha256 = "14lz8nzfy1j7snvifbwjkk1fjc8wy4jk67xk9n87r25v3cva3x0p";
  meta = {
    description = "Parse and display time according to some RFCs (RFC3339, RFC2822)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
