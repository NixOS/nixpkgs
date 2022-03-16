{ lib, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.9.0";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BY9kg0ksKfrpQgsl1aDDJJ+zKJmURqwTtKxlITxse+o=";
  };

  meta = with lib; {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
