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

  # avoid Duplicate module named "ament_mypy"
  # at build/lib/ament_mypy/__init__.py and ament_mypy/__init__.py
  postPatch = ''
    substituteInPlace ament_mypy/main.py --replace-fail \
      "if d[0] not in ['.', '_']" \
      "if d[0] not in ['.', '_'] and d != 'build'"
  '';

  build-system = [ setuptools ];

  dependencies = [ mypy ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-flake8
    ament-xmllint
    pytest-mock
  ];

  strictDeps = true;
  __structuredAttrs = true;

  env.XML_CATALOG_FILES = ament-xmllint.rosPackageCatalog;

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
