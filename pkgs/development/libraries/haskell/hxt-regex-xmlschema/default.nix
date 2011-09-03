{ cabal, hxtCharproperties, parsec }:

cabal.mkDerivation (self: {
  pname = "hxt-regex-xmlschema";
  version = "9.0.1";
  sha256 = "1mg22fa0f0cbj9gkl5zaq0xh94ljkmzrc019h3cxv728chpgby0c";
  buildDepends = [ hxtCharproperties parsec ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Regular_expressions_for_XML_Schema";
    description = "A regular expression library for W3C XML Schema regular expressions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
