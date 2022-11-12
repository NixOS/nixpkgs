{ lib, buildPythonPackage, fetchPypi, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "jplephem";
  version = "2.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SSkR6KTEeDB5GwO5oP/ff8ZfaF0cuzoXkLHqKIrn+uU=";
  };

  propagatedBuildInputs = [ numpy ];

  # Weird import error, only happens in testing:
  #   File "/build/jplephem-2.17/jplephem/daf.py", line 10, in <module>
  #     from numpy import array as numpy_array, ndarray
  # ImportError: cannot import name 'array' from 'sys' (unknown location)
  doCheck = false;

  pythonImportsCheck = [ "jplephem" ];

  meta = with lib; {
    homepage = "https://github.com/brandon-rhodes/python-jplephem/";
    description = "Python version of NASA DE4xx ephemerides, the basis for the Astronomical Alamanac";
    license = licenses.mit;
    maintainers = with maintainers; [ zane ];
  };
}
