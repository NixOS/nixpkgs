{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  dissononce,
  python-axolotl-curve25519,
  transitions,
  protobuf,
  pytestCheckHook,
  pythonOlder,
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

  patches = [
    # https://github.com/tgalal/consonance/pull/9
    (fetchpatch {
      name = "fix-type-error.patch";
      url = "https://github.com/tgalal/consonance/pull/9/commits/92fb78af98a18f0533ec8a286136968174fb0baf.patch";
      hash = "sha256-wVUGxZ4W2zPyrcQPQTc85LcRUtsLbTBVzS10NEolpQY=";
    })
  ];

  propagatedBuildInputs = [
    dissononce
    python-axolotl-curve25519
    transitions
    protobuf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/test_handshakes_offline.py" ];

  pythonImportsCheck = [ "consonance" ];

  meta = with lib; {
    description = "WhatsApp's handshake implementation using Noise Protocol";
    homepage = "https://github.com/tgalal/consonance";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
