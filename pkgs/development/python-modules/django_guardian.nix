{ stdenv, buildPythonPackage, python, fetchurl
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django, setuptools_scm
}:
buildPythonPackage rec {
  pname = "django-guardian";
  name = "${pname}-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "mirror://pypi/d/django-guardian/${name}.tar.gz";
    sha256 = "039mfx47c05vl6vlld0ahyq37z7m5g68vqc38pj8iic5ysr98drm";
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
