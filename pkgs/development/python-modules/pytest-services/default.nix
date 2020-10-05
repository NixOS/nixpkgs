{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, requests
, psutil
, pytest
, subprocess32
, zc_lockfile
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecdbee4b0cd7d4e9d84ce43d47e45c07fd5aec84d594c961c8c1c98d04c95349";
  };

  propagatedBuildInputs = [
    requests
    psutil
    pytest
    zc_lockfile
  ] ++ lib.optional (!isPy3k) subprocess32;

  # no tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Services plugin for pytest testing framework";
    homepage = "https://github.com/pytest-dev/pytest-services";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
