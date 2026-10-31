{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-lint-cmake";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_lint_cmake/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_lint_cmake" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to lint CMake code using cmakelint and generate xUnit test result files";
    mainProgram = "ament_lint_cmake";
  };
})
