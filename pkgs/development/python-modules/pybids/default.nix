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
  version = "0.9.5";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e8f8466067ff3023f53661c390c02702fcd5fe712bdd5bf167ffb0c2b920430";
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
