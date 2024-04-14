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
  version = "3.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VpH0RJUyeFirOpW5xECnm0HjVCG+Gm4JpHtsm5Qh/QY=";
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
