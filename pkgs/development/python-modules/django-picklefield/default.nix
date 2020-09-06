{ lib, buildPythonPackage, fetchFromGitHub, django, python }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "gintas";
    repo = "django-picklefield";
    rev = "v${version}";
    sha256 = "0ni7bc86k0ra4pc8zv451pzlpkhs1nyil1sq9jdb4m2mib87b5fk";
  };

  propagatedBuildInputs = [ django ];

  dontUseSetuptoolsCheck = true;

  # Taken from project's tox.ini
  checkPhase = ''
    ${python.interpreter} -m django test -v3 --settings=tests.settings
  '';

  meta = {
    description = "A pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    license = lib.licenses.mit;
  };
}
