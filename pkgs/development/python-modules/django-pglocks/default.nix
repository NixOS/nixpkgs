{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-pglocks";
  version = "1.0.3";

  meta = {
    description = "PostgreSQL locking context managers and functions for Django.";
    homepage = https://github.com/Xof/django-pglocks;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "daa3323de355b9057d8f37143e2ae8d283925fd25128ab66bb8c700d000111d9";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ django ];

  # tests need a postgres database
  doCheck = false;
}
