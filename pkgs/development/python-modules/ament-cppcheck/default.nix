{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-cppcheck";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_cppcheck/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_cppcheck" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to perform static code analysis on C/C++ code using Cppcheck and generate xUnit test result files";
    mainProgram = "ament_cppcheck";
  };
})
