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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0848cead86d3816b9c4e37cecfda31d21a4366f0dca2313ea29f3ca375c6295d";
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
    homepage = https://github.com/pytest-dev/pytest-services;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
