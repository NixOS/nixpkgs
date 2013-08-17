{ cabal, aeson, cereal, contravariant, cryptoApi, httpConduit
, httpTypes, network, pureMD5, semigroups, text, void
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.3.0.0";
  sha256 = "131p51yi17qfgk8h5b0rx2jyl37w4spafxmlcws1s5pk6bwy75jf";
  buildDepends = [
    aeson cereal contravariant cryptoApi httpConduit httpTypes network
    pureMD5 semigroups text void
  ];
  meta = {
    description = "Lastfm API interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
