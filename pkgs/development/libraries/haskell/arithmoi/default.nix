{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "arithmoi";
  version = "0.4.1.0";
  sha256 = "1xmwxmvl9l1fa2sgr4ff7al8b5d5136h4fq9r05abj3nfnx1a0iq";
  buildDepends = [ mtl random ];
  jailbreak = true;
  meta = {
    homepage = "https://bitbucket.org/dafis/arithmoi";
    description = "Efficient basic number-theoretic functions. Primes, powers, integer logarithms.";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
