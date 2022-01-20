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
  version = "4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01fe1242e706375d7c942d206a30826bd9c0dffde99bfac627050cdc91f0d792";
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
