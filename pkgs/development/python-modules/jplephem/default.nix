{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "jplephem";
  version = "2.24";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NU/hra4CImSrRvGK+2ryYhEnfP17PvkEAHVfyr6TvBE=";
  };

  propagatedBuildInputs = [ numpy ];

  # Weird import error, only happens in testing:
  #   File "/build/jplephem-2.17/jplephem/daf.py", line 10, in <module>
  #     from numpy import array as numpy_array, ndarray
  # ImportError: cannot import name 'array' from 'sys' (unknown location)
  doCheck = false;

  pythonImportsCheck = [ "jplephem" ];

  meta = {
    homepage = "https://github.com/brandon-rhodes/python-jplephem/";
    description = "Python version of NASA DE4xx ephemerides, the basis for the Astronomical Alamanac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zane ];
  };
}
