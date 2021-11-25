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
  version = "0.13.2";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9692013af3b86b096b5423b88179c6c9b604baff5a6b6f89ba5f40429feb7a3e";
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
