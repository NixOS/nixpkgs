{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, click
, num2words
, numpy
, scipy
, pandas
, nibabel
, patsy
, bids-validator
, sqlalchemy
, pytest
, pathlib
}:

buildPythonPackage rec {
  version = "0.12.3";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a084172ae5b26a5f26b17186ade98400cda52d9244d9f0b329041741ea82b5db";
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

  checkInputs = [ pytest ] ++ lib.optionals isPy27 [ pathlib ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
