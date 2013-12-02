{ cabal, c2hs, cuda }:

cabal.mkDerivation (self: {
  pname = "cufft";
  version = "0.1.0.1";
  sha256 = "0j1rsixl48z8xszym9s3rw4pwq4s5bz6inqkfsq726gni0nlm8vx";
  buildDepends = [ cuda ];
  buildTools = [ c2hs ];
  meta = {
    homepage = "http://github.com/robeverest/cufft";
    description = "Haskell bindings for the CUFFT library";
    license = self.stdenv.lib.licenses.bsd3;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
