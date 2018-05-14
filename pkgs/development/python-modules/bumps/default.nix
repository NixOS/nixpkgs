{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.6";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ahzw8ls9wsz2ks668s15zskyykib52fhi07mg50hp7lw9avqb5k";
  };

  meta = with stdenv.lib; {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
