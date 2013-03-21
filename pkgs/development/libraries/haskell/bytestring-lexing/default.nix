{ cabal, alex }:

cabal.mkDerivation (self: {
  pname = "bytestring-lexing";
  version = "0.4.2";
  sha256 = "0s9rip1ik7f29n2i88277vhy7dqhc2bb5bb9l6fd47disb78ic9h";
  buildTools = [ alex ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Parse and produce literals efficiently from strict or lazy bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
