{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, django
, setuptools_scm
, django-configurations
, pytest_xdist
, six
}:
buildPythonPackage rec {
  pname = "pytest-django";
  version = "3.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dh7jm1d37p54pgc7cx4izz6khsd860a6hw64gx74c8fjfz36p8s";
  };

  buildInputs = [ pytest setuptools_scm ];
  checkInputs = [ django-configurations pytest_xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = http://pytest-django.readthedocs.org/en/latest/;
    license = licenses.bsd3;
  };
}
