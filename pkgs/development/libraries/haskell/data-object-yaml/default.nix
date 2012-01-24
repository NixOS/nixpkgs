{ cabal, conduit, convertibleText, dataObject, failure, text
, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "data-object-yaml";
  version = "0.3.4.1";
  sha256 = "04mpa59gyfkqi5s94ps3qhphw4csiasb3lj6kf6rhhmd5yx52dnp";
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
