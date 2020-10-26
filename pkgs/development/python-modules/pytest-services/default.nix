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
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0037101eaa17e050542808ecb2e799e9b2b148f1867f62b2296329fdd2034cf5";
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
