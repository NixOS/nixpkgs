{ cabal }:

cabal.mkDerivation (self: {
  pname = "network-info";
  version = "0.2.0.2";
  sha256 = "132cna6dc8azpll3rm2y4wv6sdcavwjq3x9f8m4p2952vr53bw3m";
  meta = {
    homepage = "http://github.com/jystic/network-info";
    description = "Access the local computer's basic network configuration";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
