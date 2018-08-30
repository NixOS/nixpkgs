{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "rlp";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "040fb5172fa23d27953a886c40cac989fc031d0629db934b5a9edcd2fb28df1e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ ];

  meta = {
    description = "A package for encoding and decoding data in and from Recursive Length Prefix notation";
    homepage = "https://github.com/ethereum/pyrlp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
