{ cabal, hxtCharproperties, parsec }:

cabal.mkDerivation (self: {
  pname = "hxt-regex-xmlschema";
  version = "9.1.0";
  sha256 = "0l97rkrvl6pmxdgiwbwh2s3l00lyaihrhsffhh69639bgs67zgwr";
  buildDepends = [ hxtCharproperties parsec ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Regular_expressions_for_XML_Schema";
    description = "A regular expression library for W3C XML Schema regular expressions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
