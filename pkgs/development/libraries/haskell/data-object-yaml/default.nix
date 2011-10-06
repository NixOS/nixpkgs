{ cabal, convertibleText, dataObject, enumerator, failure, text
, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "data-object-yaml";
  version = "0.3.3.5";
  sha256 = "0ag0rac9j4ipfg9haa63s73sn7zckrpwybcfk2nbg84ix56nv36w";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    convertibleText dataObject enumerator failure text transformers
    yaml
  ];
  meta = {
    homepage = "http://github.com/snoyberg/data-object-yaml";
    description = "Serialize data to and from Yaml files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
