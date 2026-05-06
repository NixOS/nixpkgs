{
  buildPythonPackage,
  setuptools,

  mypy,

  ament-lint,

  ament-flake8,
  ament-xmllint,
  pytestCheckHook,
  pytest-mock,
}:
buildPythonPackage (finalAttrs: {
  pname = "ament-mypy";
  pyproject = true;

  inherit (ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_mypy";

  build-system = [ setuptools ];

  dependencies = [ mypy ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-flake8
    ament-xmllint
    pytest-mock
  ];

  # avoid 'Duplicate module named "ament_mypy"'
  # because ament_mypy/__init__.py + build/lib/ament_mypy/__init__.py
  preCheck = ''
    touch build/AMENT_IGNORE
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Support for mypy static type checking in ament";
    mainProgram = "ament_mypy";
  };
})
