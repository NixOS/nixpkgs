{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, requests
, psutil
, pytest
, setuptools-scm
, toml
, zc-lockfile
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "2.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2da740487d08ea63dfdf718f5d4ba11e590c99ddf5481549edebf7a3a42ca536";
  };

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    requests
    psutil
    zc-lockfile
  ];

  # no tests in PyPI tarball
  doCheck = false;

  pythonImportsCheck = [ "pytest_services" ];

  meta = with lib; {
    description = "Services plugin for pytest testing framework";
    homepage = "https://github.com/pytest-dev/pytest-services";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
