{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.16";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3594452487b8404f1efaace9b70aefaeb345fa44dd74349f7829a61161d2f69a";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
