{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, requests
, psutil
, pytest
, subprocess32
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "035bc9ce8addb33f7c2ec95a9c0c88926d213a6c2e12b2c57da31a4ec0765f2c";
  };

  propagatedBuildInputs = [
    requests
    psutil
    pytest
  ] ++ lib.optional (!isPy3k) subprocess32;

  # no tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Services plugin for pytest testing framework";
    homepage = https://github.com/pytest-dev/pytest-services;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
