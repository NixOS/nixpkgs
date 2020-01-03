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
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6c900461a6a7c450dcf11736cabc289a90f5d6f28ef74c46e32e86ffd16a4bd";
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
