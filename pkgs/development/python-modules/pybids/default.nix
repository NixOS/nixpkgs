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
  version = "0.12.1";
  pname = "pybids";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08smd4frl8hf0n6bi20ayd5wcf51g3g488bpakjciz7ghdvky1h6";
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
