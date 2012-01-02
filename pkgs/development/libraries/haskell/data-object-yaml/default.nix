{ cabal, conduit, convertibleText, dataObject, failure, text
, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "data-object-yaml";
  version = "0.3.4";
  sha256 = "1wx6m7mjmdks8ym6dh117bhkdks4d1jlfchqif0svcwg04qnfczd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    conduit convertibleText dataObject failure text transformers yaml
  ];
  meta = {
    homepage = "http://github.com/snoyberg/data-object-yaml";
    description = "Serialize data to and from Yaml files (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
