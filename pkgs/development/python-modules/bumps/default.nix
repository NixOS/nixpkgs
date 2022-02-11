{ lib, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.8.1";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4f2ee712a1e468a2ce5c0a32f67739a83331f0cb7b9c50b9e7510daefc12169";
  };

  meta = with lib; {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
