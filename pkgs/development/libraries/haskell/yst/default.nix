{cabal, HStringTemplate, HsSyck, csv, pandoc, parsec, split,
 utf8String, xhtml} :

cabal.mkDerivation (self : {
  pname = "yst";
  version = "0.2.4.1";
  sha256 = "0y620p6kn1mky30fia63na5idppfjfmc828jcaa0ads08rmj5wgy";
  propagatedBuildInputs = [
    HStringTemplate HsSyck csv pandoc parsec split utf8String xhtml
  ];
  meta = {
    homepage = "http://github.com/jgm/yst";
    description = "Builds a static website from templates and data in YAML or
CSV files.";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
