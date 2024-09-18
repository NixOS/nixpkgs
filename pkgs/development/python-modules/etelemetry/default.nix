{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  ci-info,
  ci-py,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "etelemetry";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sensein";
    repo = "etelemetry-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-UaE5JQhv2AtzXKY7YD2/g6Kj1igKhmnY3zlf1P9B/iQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ci-info
    ci-py
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "etelemetry"
    "etelemetry.client"
    "etelemetry.config"
  ];

  meta = with lib; {
    description = "Lightweight python client to communicate with the etelemetry server";
    homepage = "https://github.com/sensein/etelemetry-client";
    changelog = "https://github.com/sensein/etelemetry-client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
