{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-ZsNIw0xjxnU9Ue0C7TlhzVOCOCKEbCa2CsiiqeMb14I=";
  };

  patches = [
    # https://github.com/python-lsp/pylsp-mypy/pull/64
    (fetchpatch {
      name = "fix-hanging-test.patch";
      url = "https://github.com/python-lsp/pylsp-mypy/commit/90d28edb474135007804f1e041f88713a95736f9.patch";
      hash = "sha256-3DVyUXVImRemXCuyoXlYbPJm6p8OnhBdEKmwjx88ets=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    mypy
    python-lsp-server
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylsp_mypy"
  ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = with lib; {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://github.com/python-lsp/pylsp-mypy";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
