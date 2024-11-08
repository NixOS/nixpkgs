{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  purl,
  pytestCheckHook,
  requests,
  requests-futures,
  setuptools,
  setuptools-scm,
  testtools,
}:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6eEuMztSUVboKjyFLyIBa5FYIg0vR0VN6crop303FAE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    fixtures
    purl
    pytestCheckHook
    requests-futures
    testtools
  ];

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    changelog = "https://github.com/jamielennox/requests-mock/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
