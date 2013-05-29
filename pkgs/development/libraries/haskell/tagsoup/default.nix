{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.12.8";
  sha256 = "05cm9h80qmxvk7xhlgly9zcmpbsajagspaa8p6k4ddch6q9lj7m3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ text ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/tagsoup/";
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
