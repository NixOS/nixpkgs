{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, toml
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
  version = "1.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csernazs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hbhS1kL5VNiGjvnYkDI1LwgkqqfBMqgcao3zy716q+A=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    toml
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_wait_raise_assertion_false" # racy
  ];

  pythonImportsCheck = [
    "pytest_httpserver"
  ];

  meta = with lib; {
    description = "HTTP server for pytest to test HTTP clients";
    homepage = "https://www.github.com/csernazs/pytest-httpserver";
    changelog = "https://github.com/csernazs/pytest-httpserver/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
