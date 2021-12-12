{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.7.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64ff42ae6ef90acbded6318ed440ed63b31a669302fb60cf41265debea282a3d";
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
