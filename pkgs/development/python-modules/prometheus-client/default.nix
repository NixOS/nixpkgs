{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  twisted,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.22.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    tag = "v${version}";
    hash = "sha256-DEuIoVpRDJTd9qXBeHa5jrBscmGgosCKAluqCuUBzuU=";
  };

  build-system = [ setuptools ];

  optional-dependencies.twisted = [ twisted ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "prometheus_client" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails in darwin sandbox: Operation not permitted
    "test_instance_ip_grouping_key"
  ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
