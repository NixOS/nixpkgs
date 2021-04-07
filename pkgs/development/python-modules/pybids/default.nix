{ buildPythonPackage
, lib
, fetchPypi
, click
, num2words
, numpy
, scipy
, pandas
, nibabel
, patsy
, bids-validator
, sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.12.4";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "830f3f518ab0d2e058e9ba6d6ff9a942792909c874433b3ad58a3339a23f46bf";
  };

  propagatedBuildInputs = [
    click
    num2words
    numpy
    scipy
    pandas
    nibabel
    patsy
    bids-validator
    sqlalchemy
  ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "bids" ];

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
