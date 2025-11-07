{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
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
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "consonance";
    tag = version;
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

  env = {
    # make protobuf compatible with old versions
    # https://developers.google.com/protocol-buffers/docs/news/2022-05-06#python-updates
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  build-system = [ setuptools ];

  dependencies = [
    dissononce
    python-axolotl-curve25519
    transitions
    protobuf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/test_handshakes_offline.py" ];

  pythonImportsCheck = [ "consonance" ];

  meta = {
    description = "WhatsApp's handshake implementation using Noise Protocol";
    homepage = "https://github.com/tgalal/consonance";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
