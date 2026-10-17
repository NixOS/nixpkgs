{
  buildPythonPackage,
  darnit-core,
  hatchling,
  packaging,
}:

buildPythonPackage (finalAttrs: {
  pname = "darnit-reproducibility";
  inherit (darnit-core) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/packages/darnit-reproducibility";

  build-system = [ hatchling ];

  dependencies = [
    darnit-core
    packaging
  ];

  doCheck = false;

  pythonImportsCheck = [ "darnit_reproducibility" ];

  meta = {
    description = "Scientific reproducibility checks plugin for darnit";
    inherit (darnit-core.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
