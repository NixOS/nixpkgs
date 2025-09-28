{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    tag = "v${version}";
    hash = "sha256-sCtLokMscfuZrQVN3ok36wlnwUb+Qukkepnzs611/kU=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    twisted = [ twisted ];
  };

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
