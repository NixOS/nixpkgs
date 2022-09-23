{ lib, buildPythonPackage, fetchPypi, pysha3 }:

buildPythonPackage rec {
  pname = "merkletools";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pdik5sil0xcrwdcgdfy86c5qcfrz24r0gfc8m8bxa0i7h7x2v9l";
  };

  propagatedBuildInputs = [ pysha3 ];

  meta = with lib; {
    description = "Python tools for creating Merkle trees, generating Merkle proofs, and verification of Merkle proofs";
    homepage = "https://github.com/Tierion/pymerkletools";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
  };
}
