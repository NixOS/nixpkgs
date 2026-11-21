{
  buildPythonPackage,
  setuptools,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-uncrustify";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_uncrustify/";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_uncrustify" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against style conventions using uncrustify and generate xUnit test result files";
    mainProgram = "ament_uncrustify";
  };
})
