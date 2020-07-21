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
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "664e5f42242e5e182519388f01b9f25d824a9feb7cd17d8f863c8d776f38baf9";
  };

  nativeBuildInputs = [ pytest setuptools_scm ];
  checkInputs = [ pytest django-configurations pytest_xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
