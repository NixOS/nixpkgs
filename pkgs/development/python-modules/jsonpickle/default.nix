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

buildPythonPackage (finalAttrs: rec {
  pname = "jsonpickle";
  version = "4.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  disabledTests = [
    # AsserationError
    "test_warnings"
  ];

  pythonImportsCheck = [ "jsonpickle" ];

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    downloadPage = "https://github.com/jsonpickle/jsonpickle";
    homepage = "http://jsonpickle.github.io/";
    changelog = "https://github.com/jsonpickle/jsonpickle/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
