{ cabal, Cabal, hxtCharproperties, parsec }:

cabal.mkDerivation (self: {
  pname = "hxt-regex-xmlschema";
  version = "9.0.4";
  sha256 = "0jl89p9sb76zb6j2b9ssxaai6jq3jbnnpv4v05wfvlmk8apckwgf";
  buildDepends = [ Cabal hxtCharproperties parsec ];
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
