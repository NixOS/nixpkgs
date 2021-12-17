{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b810d396a75a5a2805272f64f4316f6dcc086e0a744b042cdb0effc85c0f21b";
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
