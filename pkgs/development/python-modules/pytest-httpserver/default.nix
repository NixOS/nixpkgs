{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  toml,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
  version = "1.0.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csernazs";
    repo = "pytest-httpserver";
    rev = "refs/tags/${version}";
    hash = "sha256-KCsZs4MGENByF/wB+aj3yvMp7lssHNVKx8jLhDQ1u4k=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ werkzeug ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    toml
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_wait_raise_assertion_false" # racy
  ];

  pythonImportsCheck = [ "pytest_httpserver" ];

  meta = with lib; {
    description = "HTTP server for pytest to test HTTP clients";
    homepage = "https://www.github.com/csernazs/pytest-httpserver";
    changelog = "https://github.com/csernazs/pytest-httpserver/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
