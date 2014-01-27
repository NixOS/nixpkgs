{ cabal, filepath, mtl, pem, time, x509, x509Store }:

cabal.mkDerivation (self: {
  pname = "x509-system";
  version = "1.4.2";
  sha256 = "1r22ignmwkv1z26bmnwh7prqy69cln26pfyyaf5r2vw8s66rgl39";
  buildDepends = [ filepath mtl pem time x509 x509Store ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "Handle per-operating-system X.509 accessors and storage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
