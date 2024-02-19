{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "refs/tags/v${version}";
    hash = "sha256-IMw0mpOUzjXBy4bMTeSFMc5pdibI5lGxZHKiufjPLbM=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prometheus_client"
  ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
