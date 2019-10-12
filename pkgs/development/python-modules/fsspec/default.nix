{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.4.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fvm1kdnnbf0pppv23mlfdqh220gcldmv72w2rdxp6ks1rcphzg3";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A specification that python filesystems should adhere to.";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
  };
}
