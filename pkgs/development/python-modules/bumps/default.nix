{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.14";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l0ljm7n19522m6mb0jnbcwdyqya15vfj3li3mvfsyv4rkxvy18b";
  };

  meta = with stdenv.lib; {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
