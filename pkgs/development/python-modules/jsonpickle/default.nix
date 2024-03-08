{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast

# build-system
, setuptools
, setuptools-scm

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "3.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-43q7pL+zykpGR9KLufRwZDb3tGyKgzO0pxirr6jkazc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  preCheck = ''
    rm pytest.ini
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # imports distutils
    "test_thing_with_submodule"
  ];

  meta = with lib; {
    description = "Python library for serializing any arbitrary object graph into JSON";
    downloadPage = "https://github.com/jsonpickle/jsonpickle";
    homepage = "http://jsonpickle.github.io/";
    license = licenses.bsd3;
  };

}
