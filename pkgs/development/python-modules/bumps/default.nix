{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.18";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3217d4fd3ec767448d742f3b6ff527cc3817f2421b9a9a8456e1d8ee4a9b1087";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
