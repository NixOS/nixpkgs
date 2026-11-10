{
  buildPythonPackage,
  hatchling,
  nab-markersets,
  nab-resolver,
  nab,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab-provider";
  inherit (nab) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/nab-provider";

  build-system = [ hatchling ];

  dependencies = [
    nab-markersets
    nab-resolver
    typing-extensions
  ];

  # The `nab` package runs this package's tests.
  doCheck = false;
  passthru.tests = { inherit nab; };

  pythonImportsCheck = [ "nab_provider" ];

  meta = {
    description = "IO-free Python packaging policy and resolution logic";
    inherit (nab.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
