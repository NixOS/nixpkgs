{
  buildPythonPackage,
  setuptools,

  ament-lint,

  ament-flake8,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "ament-pep257";
  pyproject = true;

  inherit (ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_pep257";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ ament-flake8 ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code against the docstring style conventions in PEP 257 and generate xUnit test result files";
    mainProgram = "ament_pep257";
  };
})
