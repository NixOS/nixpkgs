{
  buildPythonPackage,
  setuptools,
  pyyaml,

  ament-lint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-clang-format";
  inherit (ament-lint) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/ament_clang_format/";

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "ament_clang_format" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against style conventions using clang-format and generate xUnit test result files";
    mainProgram = "ament_clang_format";
  };
})
