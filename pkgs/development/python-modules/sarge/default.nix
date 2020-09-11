{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f48fb904e64f10ad6bef62422eaf4736acfd9b13ab64ba44822637a9dbb53265";
  };

  # No tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    homepage = "https://sarge.readthedocs.org/";
    description = "A wrapper for subprocess which provides command pipeline functionality";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
