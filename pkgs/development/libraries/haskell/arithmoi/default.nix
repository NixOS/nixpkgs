{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "arithmoi";
  version = "0.4.0.4";
  sha256 = "1v8qn0gjvlds6ljm9sfzzi5w3gsf7x63z0r7hcs1rvn0n3acwz6y";
  buildDepends = [ mtl random ];
  meta = {
    homepage = "https://bitbucket.org/dafis/arithmoi";
    description = "Efficient basic number-theoretic functions. Primes, powers, integer logarithms.";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
