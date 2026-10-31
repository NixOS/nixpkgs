{
  buildPythonPackage,
  hatchling,
  nab,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab-resolver";
  inherit (nab) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/nab-resolver";

  build-system = [ hatchling ];

  # The `nab` package runs this package's tests.
  doCheck = false;
  passthru.tests = { inherit nab; };

  pythonImportsCheck = [ "nab_resolver" ];

  meta = {
    description = "Generic PubGrub dependency resolver core";
    inherit (nab.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
