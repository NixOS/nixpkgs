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
  version = "0.10.0";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b37ba89eb7407bbfdf8e26e1230b6ef452da3d986df5eed21aab96be61b6e844";
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
