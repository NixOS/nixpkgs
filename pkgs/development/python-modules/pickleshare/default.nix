{ lib
, buildPythonPackage
, fetchPypi
, path
, pathlib2
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.7.5";
  pname = "pickleshare";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca";
  };

  propagatedBuildInputs = [ path ]
    ++ lib.optional (pythonOlder "3.4") pathlib2;

  # No proper test suite
  doCheck = false;

  meta = with lib; {
    description = "Tiny 'shelve'-like database with concurrency support";
    homepage = "https://github.com/vivainio/pickleshare";
    license = licenses.mit;
  };

}
