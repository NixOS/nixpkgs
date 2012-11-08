{ cabal, systemFilepath, text }:

cabal.mkDerivation (self: {
  pname = "ReadArgs";
  version = "1.2";
  sha256 = "0qkrg9kii15gl5pqzk63vmcs2w3clwdsxzlc5g224cwi3rnc6flp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ systemFilepath text ];
  meta = {
    homepage = "http://github.com/rampion/ReadArgs";
    description = "Simple command line argument parsing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
