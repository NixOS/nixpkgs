{ cabal, convertibleText, dataObject, enumerator, failure, text
, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "data-object-yaml";
  version = "0.3.3.6";
  sha256 = "0hha52nrxb539bvdz6ksn9sxmksfwmjhh7h8mp223s340vxrlpk3";
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
