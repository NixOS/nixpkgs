{ lib
, fetchPypi
, buildPythonPackage
, six
, numpy
, scipy # optional, allows spline-related features (see patsy's docs)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5053de7804676aba62783dbb0f23a2b3d74e35e5bfa238b88b7cbf148a38b69d";
  };

  propagatedBuildInputs = [
    six
    numpy
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "patsy"
  ];

  meta = {
    description = "A Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}

