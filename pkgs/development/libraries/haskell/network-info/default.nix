{ cabal }:

cabal.mkDerivation (self: {
  pname = "network-info";
  version = "0.2.0.3";
  sha256 = "04nwl5akrsppxkqqq7a7qi5sixvrzvj4njl8rbz7sglbh9393rs2";
  meta = {
    homepage = "http://github.com/jystic/network-info";
    description = "Access the local computer's basic network configuration";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
