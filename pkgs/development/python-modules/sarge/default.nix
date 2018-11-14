{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.5.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da8cc90883f8e5ab4af0d746438f608662f5f2a35da2e858517927edefa134b0";
  };

  # No tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    homepage = http://sarge.readthedocs.org/;
    description = "A wrapper for subprocess which provides command pipeline functionality";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
