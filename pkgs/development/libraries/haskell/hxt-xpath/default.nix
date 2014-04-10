{ cabal, filepath, hxt, parsec }:

cabal.mkDerivation (self: {
  pname = "hxt-xpath";
  version = "9.1.2.1";
  sha256 = "0r9xzxwdqaj0arz9pv6f272dz73m83agbln9q9bclmgqys6l0kr9";
  buildDepends = [ filepath hxt parsec ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "The XPath modules for HXT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
