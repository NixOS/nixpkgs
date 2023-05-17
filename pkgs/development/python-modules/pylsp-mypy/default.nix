{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-9B+GSEoQEqd1W/g0oup4xULKWOF0TgSG5DfBtyWA3vs=";
  };

  propagatedBuildInputs = [
    mypy
    python-lsp-server
    toml
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
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
