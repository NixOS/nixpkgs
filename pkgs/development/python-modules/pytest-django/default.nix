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
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17592f06d51c2ef4b7a0fb24aa32c8b6998506a03c8439606cb96db160106659";
  };

  nativeBuildInputs = [ pytest setuptools_scm ];
  checkInputs = [ pytest django-configurations pytest_xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = https://pytest-django.readthedocs.org/en/latest/;
    license = licenses.bsd3;
  };
}
