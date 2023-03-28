{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, varint
, base58
, netaddr
, idna
, py-cid
, py-multicodec
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-multiaddr";
  version = "0.0.9";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cGM7iYQPP+UOkbTxRhzuED0pkcydFCO8vpx9wTc0/HI=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    varint
    base58
    netaddr
    idna
    py-cid
    py-multicodec
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "multiaddr" ];

  meta = with lib; {
    description = "Composable and future-proof network addresses";
    homepage = "https://github.com/multiformats/py-multiaddr";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ Luflosi ];
  };
}
