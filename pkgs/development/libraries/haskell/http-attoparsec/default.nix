{ cabal, attoparsec, httpTypes }:

cabal.mkDerivation (self: {
  pname = "http-attoparsec";
  version = "0.1.0";
  sha256 = "1ncdjzgb5kv20y9kps4nawvbwaqnfil9g552if638vv8hag8cwq9";
  buildDepends = [ attoparsec httpTypes ];
  meta = {
    homepage = "https://github.com/tlaitinen/http-attoparsec";
    description = "Attoparsec parsers for http-types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
