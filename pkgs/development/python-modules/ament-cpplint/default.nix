{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-cpplint";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_cpplint/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_cpplint" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against the Google style conventions using cpplint and generate xUnit test result files";
    mainProgram = "ament_cpplint";
  };
})
