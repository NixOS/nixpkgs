{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asserts,
  mypy,

  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "htmlgen";
  version = "2.0.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srittau";
    repo = "python-htmlgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RmJKaaTB+xvsJ+9jM21ZUNVTlr7ebPW785A8OXrpDoY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mypy
  ];

  nativeCheckInputs = [
    asserts
    unittestCheckHook
  ];

  unittestFlags = [
    "--start"
    "test_htmlgen"
    "--pattern"
    "*.py"
  ];

  pythonImportsCheck = [
    "htmlgen"
  ];

  meta = {
    description = "Python HTML 5 Generator";
    homepage = "https://github.com/srittau/python-htmlgen";
    changelog = "https://github.com/srittau/python-htmlgen/blob/v${finalAttrs.version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
