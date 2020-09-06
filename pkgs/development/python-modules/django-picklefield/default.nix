{ lib, buildPythonPackage, fetchFromGitHub, django, pytest, pytest-django }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "3.0.1";

  # The PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "gintas";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ni7bc86k0ra4pc8zv451pzlpkhs1nyil1sq9jdb4m2mib87b5fk";
  };

  propagatedBuildInputs = [ django ];

  checkInputs = [ pytest pytest-django ];

  checkPhase = ''
    PYTHONPATH="$(pwd):$PYTHONPATH" \
    DJANGO_SETTINGS_MODULE=tests.settings \
      pytest tests/tests.py
  '';

  meta = {
    description = "A pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    license = lib.licenses.mit;
  };
}
