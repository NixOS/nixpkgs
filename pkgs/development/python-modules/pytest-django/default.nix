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
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ktb9RrHXm1T7awYLuzlCgHM5bOxxfV8uEiqZDUtqpeg=";
  };

  nativeBuildInputs = [ pytest setuptools-scm ];
  nativeCheckInputs = [ pytest django-configurations pytest-xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
