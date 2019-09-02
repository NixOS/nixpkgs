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
  version = "3.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d489db7c9bd18d7c154347b1bdfb82cc6b1ec8539543508b199c77e5eb2caec";
  };

  nativeBuildInputs = [ pytest setuptools_scm ];
  checkInputs = [ pytest django-configurations pytest_xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = http://pytest-django.readthedocs.org/en/latest/;
    license = licenses.bsd3;
  };
}
