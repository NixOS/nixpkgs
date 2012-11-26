{ cabal, aeson, attoparsec, curl, mtl, pureMD5, urlencoded
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.0.3.7";
  sha256 = "004mi6515gd6vhk7fjd63rwwnf3micm3z1kwcn1f73hi70p27ma0";
  buildDepends = [
    aeson attoparsec curl mtl pureMD5 urlencoded utf8String xml
  ];
  patchPhase = ''
    sed -i -e 's|curl == .*,|curl,|' -e 's|urlencoded .*,|urlencoded,|' liblastfm.cabal
  '';
  meta = {
    description = "Wrapper to Lastfm API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
