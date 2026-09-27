{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-pycodestyle";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_pycodestyle/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_pycodestyle" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against the style conventions in PEP 8 and generate xUnit test result files";
    mainProgram = "ament_pycodestyle";
  };
})
