{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.7";
  sha256 = "0pwzgmgc87xms4r7pqymq56qgi601pk195kj62rll05qip6mrba0";
  buildDepends = [ network ];
  meta = {
    homepage = "http://hub.darcs.net/stepcut/sendfile";
    description = "A portable sendfile library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
