{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asgiref,
  twisted,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    tag = "v${version}";
    hash = "sha256-4swqhoCVrD7GflFbQX+QH9yGVDjbfwXvd7trs30STQQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ asgiref ];

  optional-dependencies.twisted = [ twisted ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "prometheus_client" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails in darwin sandbox: Operation not permitted
    "test_instance_ip_grouping_key"
  ];

  meta = {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
