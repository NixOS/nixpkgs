{ lib
, buildPythonPackage
, fetchPypi
, pytest
, django
, setuptools-scm
, django-configurations
, pytest-xdist
, six
}:
buildPythonPackage rec {
  pname = "pytest-django";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5171e3798bf7e3fc5ea7072fe87324db67a4dd9f1192b037fed4cc3c1b7f455";
  };

  nativeBuildInputs = [ pytest setuptools-scm ];
  checkInputs = [ pytest django-configurations pytest-xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
