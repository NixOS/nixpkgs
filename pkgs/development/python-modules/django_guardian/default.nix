{ stdenv, buildPythonPackage, python, fetchPypi
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django, setuptools_scm
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e144bbdfa67f523dc6f70768653a19c0aac29394f947a80dcb8eb7900840637";
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
