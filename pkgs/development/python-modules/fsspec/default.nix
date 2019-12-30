{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.6.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffd7cd5ac32f36698097c3d78c2c433d4c12f7e4bce3a3a4036fd3491188046d";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A specification that python filesystems should adhere to.";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
  };
}
