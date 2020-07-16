{ lib
, buildPythonPackage
, fetchPypi
, ecdsa
, pysha3
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8397a315c2f656ccf37ff1c43f5e0d496a10ea692c614fdf9bae1a3d5de3558";
  };

  propagatedBuildInputs = [ ecdsa pysha3 ];

  # tests are not packaged in the released tarball
  doCheck = false;

  pythonImportsCheck = [
    "bip_utils"
  ];

  meta = {
    description = "Implementation of BIP39, BIP32, BIP44, BIP49 and BIP84 for wallet seeds, keys and addresses generation";
    homepage = "https://github.com/ebellocchia/bip_utils";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
