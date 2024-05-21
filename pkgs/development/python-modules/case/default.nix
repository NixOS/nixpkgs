{ lib
, buildPythonPackage
, fetchPypi
, pynose
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "case";
  version = "1.5.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48432b01d91913451c3512c5b90e31b0f348f1074b166a3431085eb70d784fb1";
  };

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    # replaced with pynopse for python 3.12 compat
    "nose"
  ];

  dependencies = [
    pynose
    six
  ];

  # No real unittests, only coverage
  doCheck = false;

  pythonImportsCheck = [
    "case"
  ];

  meta = with lib; {
    homepage = "https://github.com/celery/case";
    description = "Utilities for unittests handling";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
