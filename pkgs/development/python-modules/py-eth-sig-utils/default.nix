{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-abi
, py-ecc
, pycryptodome
, python
, rlp
}:

buildPythonPackage rec {
  pname = "py-eth-sig-utils";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rmeissner";
    repo = "py-eth-sig-utils";
    rev = "v${version}";
    sha256 = "sha256-PNvEHH5w2ptntRGzqWrqlbIzJJsT60OXg/Dh5f6Wq9k=";
  };

  propagatedBuildInputs = [
    eth-abi
    py-ecc
    pycryptodome
    rlp
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "py_eth_sig_utils" ];

  meta = with lib; {
    description = "Collection of functions to generate hashes for signing on Ethereum";
    homepage = "https://github.com/rmeissner/py-eth-sig-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
