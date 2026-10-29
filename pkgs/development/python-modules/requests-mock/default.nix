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

buildPythonPackage (finalAttrs: {
  pname = "requests-mock";
  version = "1.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-6eEuMztSUVboKjyFLyIBa5FYIg0vR0VN6crop303FAE=";
  };

  postPatch = ''
    substituteInPlace tests/test_mocker.py \
      --replace-fail assertEquals assertEqual
  '';

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

  meta = {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    changelog = "https://github.com/jamielennox/requests-mock/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
