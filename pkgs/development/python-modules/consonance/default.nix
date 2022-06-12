{ lib
, buildPythonPackage
, fetchFromGitHub
, dissononce
, python-axolotl-curve25519
, transitions
, protobuf
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "consonance";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "consonance";
    rev = version;
    hash = "sha256-BhgxLxjKZ4dSL7DqkaoS+wBPCd1SYZomRKrtDLdGmYQ=";
  };

  propagatedBuildInputs = [
    dissononce
    python-axolotl-curve25519
    transitions
    protobuf
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test_handshakes_offline.py"
  ];

  pythonImportsCheck = [
    "consonance"
  ];

  meta = with lib; {
    description = "WhatsApp's handshake implementation using Noise Protocol";
    homepage = "https://github.com/tgalal/consonance";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
