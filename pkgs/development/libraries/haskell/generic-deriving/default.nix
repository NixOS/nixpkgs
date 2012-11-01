{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.3.1";
  sha256 = "1z02j86lgn57ws0rfq2m0zb0m866k9afh9346k8bbwb5c4914wm3";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
