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
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "prometheus-client";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vue/5ulOnKkYjiHYWgT6HZ5mhV2vqAstm44+zwm+po0=";
  };

  build-system = [ setuptools ];

  dependencies = [ asgiref ];

  optional-dependencies.twisted = [ twisted ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "prometheus_client" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails in darwin sandbox: Operation not permitted
    "test_instance_ip_grouping_key"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
