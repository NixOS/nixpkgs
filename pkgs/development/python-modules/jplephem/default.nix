{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "jplephem";
  version = "2.22";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DZrMche0gG/rqT5yl0zurVYREEvOZ4mvONTyfc96WSw=";
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
