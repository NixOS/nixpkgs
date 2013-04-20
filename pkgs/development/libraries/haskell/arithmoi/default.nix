{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "arithmoi";
  version = "0.4.0.3";
  sha256 = "0idn312xzly636h13zmm7cw7ki64bpnniqc97nshqzgp8if5ycrc";
  buildDepends = [ mtl random ];
  meta = {
    homepage = "https://bitbucket.org/dafis/arithmoi";
    description = "Efficient basic number-theoretic functions. Primes, powers, integer logarithms.";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
