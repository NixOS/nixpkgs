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
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fynkswykgnqn8wqibavf598md5p005ilcac6sk4hpfv0v2v8kr6";
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
