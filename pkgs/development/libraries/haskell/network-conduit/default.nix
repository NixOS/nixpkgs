{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.5.0";
  sha256 = "0q7smsrv3gp5kvzqfgw2mw9w70gjr5pkx2bmk58dvbnz6al85abn";
  buildDepends = [
    conduit liftedBase monadControl network transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Stream socket data using conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
