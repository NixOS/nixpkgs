{
  buildPythonPackage,
  setuptools,

  ament-lint,

  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-clang-tidy";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_clang_tidy/";

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "ament_clang_tidy" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against style conventions using clang-tidy and generate xUnit test result files";
    mainProgram = "ament_clang_tidy";
  };
})
