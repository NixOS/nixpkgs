{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  six,
}:

buildPythonPackage rec {
  pname = "django-pglocks";
  version = "1.0.4";
  format = "setuptools";

  meta = {
    description = "PostgreSQL locking context managers and functions for Django";
    homepage = "https://github.com/Xof/django-pglocks";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PEfGb7+9Jo70YmlnOgUWoDlTmwlyuO0uyc/uRMS2VSM=";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [
    django
    six
  ];

  # tests need a postgres database
  doCheck = false;
}
