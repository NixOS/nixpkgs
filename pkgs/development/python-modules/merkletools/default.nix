{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "merkletools";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Tierion";
    repo = "pymerkletools";
    tag = version;
    hash = "sha256-pd7Wxi7Sk95RcrFOTOtl725nIXidva3ftdKSGxHYPTA=";
  };

  postPatch = ''
    # pysha3 is deprecated and not needed for Python > 3.6
    substituteInPlace setup.py \
      --replace "install_requires=install_requires" "install_requires=[],"
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "merkletools" ];

  meta = {
    description = "Python tools for creating Merkle trees, generating Merkle proofs, and verification of Merkle proofs";
    homepage = "https://github.com/Tierion/pymerkletools";
    changelog = "https://github.com/Tierion/pymerkletools/releases/tag/${version}";
    license = lib.licenses.mit;
  };
}
