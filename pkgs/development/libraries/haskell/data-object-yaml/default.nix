{ cabal, Cabal, conduit, convertibleText, dataObject, failure, text
, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "data-object-yaml";
  version = "0.3.4.2";
  sha256 = "18a9r4wfpb7icjb6nji9iy3abq6sxafmsnfwqpnm1nn2nn3fm1ap";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal conduit convertibleText dataObject failure text transformers
    yaml
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
