{
  buildPythonPackage,
  setuptools,

  ament-lint,

  flake8,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "ament-flake8";
  pyproject = true;

  inherit (ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_flake8";

  build-system = [ setuptools ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check code for style and syntax conventions with flake8";
    mainProgram = "ament_flake8";
  };
})
