{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pytest-celery";
  version = "0.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfd060fc32676afa1e4f51b2938f903f7f75d952186b8c6cf631628c4088f406";
  };

  patches = [ ./no-celery.patch ];

  doCheck = false; # This package has nothing to test or import.

  meta = with lib; {
    description = "pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
    maintainers = [ ];
  };
}
