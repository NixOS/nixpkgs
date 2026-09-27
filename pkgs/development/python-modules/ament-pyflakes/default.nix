{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-pyflakes";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_pyflakes/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_pyflakes" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code using pyflakes and generate xUnit test result files";
    mainProgram = "ament_pyflakes";
  };
})
