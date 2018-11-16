{ stdenv, buildPythonPackage, python, fetchPypi
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django, setuptools_scm
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "1.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3c0ab257c9d94ce154b9ee32994e3cff8b350c384040705514e14a9fb7c8191";
  };

  checkInputs = [ pytest pytestrunner pytest-django django_environ mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ django six ];

  checkPhase = ''
    ${python.interpreter} nix_run_setup test --addopts="--ignore build"
  '';

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = https://github.com/django-guardian/django-guardian;
    license = [ licenses.mit licenses.bsd2 ];
  };
}
