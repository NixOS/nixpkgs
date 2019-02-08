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
  version = "3.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r190xb707817la5kw5i3m646ijmg025zqy55gz16py94wsnav5y";
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
