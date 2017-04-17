{ stdenv, buildPythonPackage, python, fetchurl
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django, setuptools_scm
}:
buildPythonPackage rec {
  name = "django-guardian-${version}";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://pypi/d/django-guardian/${name}.tar.gz";
    sha256 = "1r3xj0ik0hh6dfak4kjndxk5v73x95nfbppgr394nhnmiayv4zc5";
  };

  buildInputs = [ pytest pytestrunner pytest-django django_environ mock setuptools_scm ];
  propagatedBuildInputs = [ django six ];

  checkPhase = ''
    ${python.interpreter} nix_run_setup.py test --addopts="--ignore build"
  '';

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = https://github.com/django-guardian/django-guardian;
    licenses = [ licenses.mit licenses.bsd2 ];
  };
}
