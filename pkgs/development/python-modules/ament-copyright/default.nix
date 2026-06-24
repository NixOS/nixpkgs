{
  buildPythonPackage,
  setuptools,

  ament-lint,

  ament-flake8,
  ament-pep257,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "ament-copyright";
  pyproject = true;

  inherit (ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_copyright";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-flake8
    ament-pep257
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check source files for copyright and license information";
    mainProgram = "ament_copyright";
  };
})
