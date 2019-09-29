{ stdenv, buildPythonPackage, fetchPypi, six}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.7.12";

  propagatedBuildInputs = [six];

  # Bumps does not provide its own tests.py, so the test
  # always fails
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a8m56bwyi0gdrf3kgkdw3cajyxlr40qrj1xlh5yn4qqjbz7ym02";
  };

  meta = with stdenv.lib; {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "Data fitting with bayesian uncertainty analysis";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.publicDomain;
  };
}
