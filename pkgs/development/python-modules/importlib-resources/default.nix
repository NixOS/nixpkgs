{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  importlib-metadata,

  # Reverse dependency
  sage,

  # tests
  jaraco-collections,
  jaraco-test,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "6.4.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-mAhiodFsnhR6WWA2d/oqpf2CuH8iO2y4cGlbz86DAGU=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/python/importlib_resources/issues/318
      name = "python-3.13-compat.patch";
      url = "https://github.com/python/importlib_resources/commit/8684c7a028b65381ec6c6724e2f9c9bea7df0aee.patch";
      hash = "sha256-mb2V4rQPKyi5jMQ+yCf9fY3vHxB54BhvLzy2NNc0zNc=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    jaraco-collections
    jaraco-test
  ];

  pythonImportsCheck = [ "importlib_resources" ];

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
