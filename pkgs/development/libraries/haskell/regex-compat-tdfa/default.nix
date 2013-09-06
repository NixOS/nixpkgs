{ cabal, regexBase, regexTdfa }:

cabal.mkDerivation (self: {
  pname = "regex-compat-tdfa";
  version = "0.95.1.2";
  sha256 = "0b7pp5xq4ybgji5shz5v1a91y6wwzila3vjiyq4nma0xj3njy802";
  buildDepends = [ regexBase regexTdfa ];
  meta = {
    homepage = "http://hub.darcs.net/shelarcy/regex-compat-tdfa";
    description = "Unicode Support version of Text.Regex, using regex-tdfa";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
