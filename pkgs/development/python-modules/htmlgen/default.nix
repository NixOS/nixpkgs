{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asserts,
  mypy,
}:

buildPythonPackage rec {
  pname = "htmlgen";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srittau";
    repo = "python-htmlgen";
    tag = "v${version}";
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
  ];
  # From some reason, using unittestCheckHook doesn't work, and the list of
  # test files have to be used explicitly, and also without the `discover`
  # argument.
  checkPhase = ''
    runHook preCheck

    python -m unittest test_htmlgen/*.py

    runHook postCheck
  '';

  pythonImportsCheck = [
    "htmlgen"
  ];

  meta = {
    description = "Python HTML 5 Generator";
    homepage = "https://github.com/srittau/python-htmlgen";
    changelog = "https://github.com/srittau/python-htmlgen/blob/v${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
