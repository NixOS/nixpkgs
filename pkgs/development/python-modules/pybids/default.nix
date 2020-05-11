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
  version = "0.10.2";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6571ef82e03a958e56aa61cf5b15392f0b2d5dbca92f872061d81524e8da8525";
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
    homepage = "https://github.com/bids-standard/pybids";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
