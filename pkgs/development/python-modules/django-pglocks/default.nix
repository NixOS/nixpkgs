{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-pglocks";
  version = "1.0.4";

  meta = {
    description = "PostgreSQL locking context managers and functions for Django.";
    homepage = https://github.com/Xof/django-pglocks;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c47c66fbfbd268ef46269673a0516a039539b0972b8ed2ec9cfee44c4b65523";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ django ];

  # tests need a postgres database
  doCheck = false;
}
