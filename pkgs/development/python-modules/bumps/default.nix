{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.8.0";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f92c05effd8175763799d19ca55592e89b053318f611148a6725159aea41d67";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
