{ lib
, buildPythonPackage
, fetchPypi
, coverage
, nose
, six
, python
}:

buildPythonPackage rec {
  pname = "cycler";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f";
  };

  nativeCheckInputs = [ coverage nose ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # Tests were not included in release.
  # https://github.com/matplotlib/cycler/issues/31
  doCheck = false;

  meta = {
    description = "Composable style cycles";
    homepage = "https://github.com/matplotlib/cycler";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
