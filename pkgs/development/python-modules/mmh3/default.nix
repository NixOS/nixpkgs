{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mw8rKrSpFTM8nRCJVy4pCgIeu1uQC7f3EU3MwDmV1zI=";
  };

  pythonImportsCheck = [ "mmh3" ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://pypi.org/project/mmh3/";
    license = licenses.cc0;
  };
}
