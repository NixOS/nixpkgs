{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "4.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iv7RiqGJ/YHi6DO0JrtK9IVZSSHwsdNsIAH8Vjei8hA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  preCheck = ''
    rm pytest.ini
  '';

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # imports distutils
    "test_thing_with_submodule"
  ];

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    downloadPage = "https://github.com/jsonpickle/jsonpickle";
    homepage = "http://jsonpickle.github.io/";
    license = lib.licenses.bsd3;
  };
}
