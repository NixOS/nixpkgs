{
  buildPythonPackage,
  hatchling,
  nab,
  packaging,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab-markersets";
  inherit (nab) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/nab-markersets";

  build-system = [ hatchling ];

  dependencies = [
    packaging
  ];

  # The `nab` package runs this package's tests.
  doCheck = false;
  passthru.tests = { inherit nab; };

  pythonImportsCheck = [ "nab_markersets" ];

  meta = {
    description = "PEP 508 marker algebra with markers as sets of environments";
    inherit (nab.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
