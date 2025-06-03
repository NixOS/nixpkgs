{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
  greenlet,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-httpbin,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ross";
    repo = "requests-futures";
    tag = "v${version}";
    hash = "sha256-eUu+M9rPyvc7OaOCCnUvGliK4gicYh6hfB0Jo19Yy1g=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    greenlet
    pytestCheckHook
    pytest-cov-stub
    pytest-httpbin
    werkzeug
  ];

  pythonImportsCheck = [ "requests_futures" ];

  meta = with lib; {
    description = "Asynchronous Python HTTP Requests for Humans using Futures";
    homepage = "https://github.com/ross/requests-futures";
    changelog = "https://github.com/ross/requests-futures/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ applePrincess ];
  };
}
