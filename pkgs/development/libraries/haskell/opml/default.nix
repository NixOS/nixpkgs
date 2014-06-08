{ cabal, xml }:

cabal.mkDerivation (self: {
  pname = "opml";
  version = "0.4";
  sha256 = "1bnr6lkcf2qs7pvrmd8a5xmklcg67l64b776hzclfvxqy1qil29x";
  buildDepends = [ xml ];
  meta = {
    description = "Representing and handling OPML subscription information";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
