{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.13";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fdcf335b800d892edfdbc87fdd539cb45166d8667edbec3dfbb1a3b5c3a35547";
  };

  meta = with stdenv.lib; {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
