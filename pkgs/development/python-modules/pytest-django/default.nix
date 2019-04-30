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
  version = "3.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vj2xfb6jl570zmmwlhvfpj7af5q554z72z51ril07gyfkkq6cjd";
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
