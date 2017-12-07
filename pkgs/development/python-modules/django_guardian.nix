{ stdenv, buildPythonPackage, python, fetchurl
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django, setuptools_scm
}:
buildPythonPackage rec {
  pname = "django-guardian";
  name = "${pname}-${version}";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://pypi/d/django-guardian/${name}.tar.gz";
    sha256 = "c3c0ab257c9d94ce154b9ee32994e3cff8b350c384040705514e14a9fb7c8191";
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
