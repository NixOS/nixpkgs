{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1ec578c09a07d3518ec9be540b87546397fa3455de73c166fcce51eaa5c41c5";
  };

  pythonImportsCheck = [ "mmh3" ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://pypi.org/project/mmh3/";
    license = licenses.cc0;
  };
}
