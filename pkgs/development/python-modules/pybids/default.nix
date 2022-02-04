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
  version = "0.14.0";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73c4d03aad333f2a7cb4405abe96f55a33cffa4b5a2d23fad6ac5767c45562ef";
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
    # Doesn't support sqlalchemy >=1.4
    # See https://github.com/bids-standard/pybids/issues/680
    broken = true;
  };
}
