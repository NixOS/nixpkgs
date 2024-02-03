{ lib, buildPythonPackage, fetchPypi, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "jplephem";
  version = "2.19";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wWJFTGVtblID/5cB2CZnH6+fMgnZccu2jdtGAD3/bc8=";
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
