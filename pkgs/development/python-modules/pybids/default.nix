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
  version = "0.15.4";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ADrMtaApWyLs2e9x85rYGhZKSgG13P+h4fzjW/TR/mg=";
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
