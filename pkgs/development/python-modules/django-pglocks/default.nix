{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-pglocks";
  version = "1.0.2";

  meta = {
    description = "PostgreSQL locking context managers and functions for Django.";
    homepage = https://github.com/Xof/django-pglocks;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ks4k0bk4457wfl3xgzr4v7xb0lxmnkhxwhlp0bbnmzipdafw1cl";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ django ];

  # tests need a postgres database
  doCheck = false;
}
