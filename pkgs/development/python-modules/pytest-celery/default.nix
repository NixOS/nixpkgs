{ lib, buildPythonPackage, fetchPypi, pytest, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-celery";
  version = "0.0.0a1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qifwi7q8dfwbzz2vm5m40lw23qh2fzibngbmw6qgwnkq8bhh3iy";
  };

  patches = [ ./no-celery.patch ];

  doCheck = false; # This package has nothing to test or import.

  meta = with lib; {
    description = "pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
  };
}
