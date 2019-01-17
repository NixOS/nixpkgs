{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a67c34d3a44892d3e2a0af0ac55c02b949a37ced9d55c0d7ade76362ba6692d7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # tests not packaged with PyPi download
  doCheck = false;

  meta = {
    description = "Python package for docstring repetition";
    homepage = https://github.com/Chilipp/docrep;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
