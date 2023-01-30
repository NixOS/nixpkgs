{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-keys
, eth-utils
, pycryptodome
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eth-keyfile";
  version = "0.6.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keyfile";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-JD4bRoD9L0JXcd+bTZrq/BkWw5QGzOi1RvoyLJC77kk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'setuptools-markdown'" ""
  '';

  propagatedBuildInputs = [
    eth-keys
    eth-utils
    pycryptodome
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eth_keyfile" ];

  meta = with lib; {
    description = "Tools for handling the encrypted keyfile format used to store private keys";
    homepage = "https://github.com/ethereum/eth-keyfile";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
