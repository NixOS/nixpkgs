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
  version = "3.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b379282feaf89069cb790775ab6bbbd2bd2038a68c7ef9b84a41898e0b551081";
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
