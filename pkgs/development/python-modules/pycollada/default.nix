{ lib, fetchPypi, buildPythonPackage, numpy, python-dateutil }:

buildPythonPackage rec {
  pname = "pycollada";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70a2630ed499bdab718c0e61a3e6ae3698130d7e4654e89cdecde51bfdaea56f";
  };

  propagatedBuildInputs = [ numpy python-dateutil ];

  # Some tests fail because they refer to test data files that don't exist
  # (upstream packaging issue)
  doCheck = false;

  meta = with lib; {
    description = "Python library for reading and writing collada documents";
    homepage = "http://pycollada.github.io/";
    license = "BSD"; # they don't specify which BSD variant
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
