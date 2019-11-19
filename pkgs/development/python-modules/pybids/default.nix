{ buildPythonPackage
, lib
, fetchPypi
, isPy27
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
  version = "0.9.4";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08abd3573e823e536990caf54405ffef573a88ef9d019c2d94e0be995e21885f";
  };

  propagatedBuildInputs = [
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
    homepage = https://github.com/bids-standard/pybids;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
