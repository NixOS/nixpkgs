{cabal, haddock, binary, binaryShared, deepseq, hslogger, ltk, mtl,
 network, parsec, processLeksah}:

cabal.mkDerivation (self : {
  pname = "leksah-server";
  version = "0.8.0.8";
  sha256 = "10srf3wzrnyjhw7q8lzzfqammjr9k1fgwqlkkcfkljbmsz9j0nfm";
  propagatedBuildInputs =
    [binary binaryShared deepseq hslogger ltk mtl network parsec processLeksah haddock];
  meta = {
    description = "The interface to GHC-API for leksah";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
