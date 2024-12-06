{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  twisted,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.21.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "refs/tags/v${version}";
    hash = "sha256-LrCBCfIcpxNjy/yjwCG4J34eJO4AdUr21kp9FBwSeAY=";
  };

  build-system = [ setuptools ];

  optional-dependencies.twisted = [ twisted ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "prometheus_client" ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
