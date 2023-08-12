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
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vcGAAYdeMZvJHIEsHrahC+S7E8uB63Y/RmF53KO2cnc=";
  };

  propagatedBuildInputs = [
    six
    numpy
    scipy
  ];

  nativeCheckInputs = [
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

