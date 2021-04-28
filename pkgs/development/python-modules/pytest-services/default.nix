{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, requests
, psutil
, pytest
, setuptools_scm
, subprocess32 ? null
, toml
, zc_lockfile
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2da740487d08ea63dfdf718f5d4ba11e590c99ddf5481549edebf7a3a42ca536";
  };

  nativeBuildInputs = [
    setuptools_scm
    toml
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    requests
    psutil
    zc_lockfile
  ] ++ lib.optional (!isPy3k) subprocess32;

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
