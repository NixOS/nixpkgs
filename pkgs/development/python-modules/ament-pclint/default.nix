{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-pclint";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_pclint/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_pclint" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to perform static code analysis on C/C++ code using PC-lint and generate xUnit test result files";
    mainProgram = "ament_pclint";
  };
})
