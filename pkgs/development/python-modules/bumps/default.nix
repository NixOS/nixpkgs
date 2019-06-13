{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.11";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16d24a7f965592d9b02f96e68e6aa70d6fb59abe4db37bb14c4b60c509a3c2ef";
  };

  meta = with stdenv.lib; {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
