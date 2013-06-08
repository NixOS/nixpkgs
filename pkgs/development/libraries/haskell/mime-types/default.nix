{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime-types";
  version = "0.1.0.3";
  sha256 = "0mzhkqcjlnrs9mwn2crsr1m2mf6pgygs1s3ks8akz1618v6jm6y1";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Basic mime-type handling types and functions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
