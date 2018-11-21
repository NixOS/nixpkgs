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
  version = "3.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07zl2438gavrcykva6i2lpxmzgf90h4xlm3nqgd7wsqz2yh727zy";
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
