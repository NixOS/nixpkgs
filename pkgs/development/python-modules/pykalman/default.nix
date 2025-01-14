{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "pykalman";
  version = "0.9.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gWr0dyDZJKTGAW+nS54sjCEWWgjZFpPDIqF0Ho4H+zg=";
  };

  patches = [
    # https://github.com/pykalman/pykalman/issues/83
    ./fix-masked-arrays-not-supported.patch
    # python 3.11 issues fix: https://github.com/pykalman/pykalman/pull/101
    ./fix-p311-issues.patch
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nose
  ];
  pythonImportsCheck = [ "pykalman" ];

  meta = with lib; {
    description = "An implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
