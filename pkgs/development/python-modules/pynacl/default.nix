{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  sphinxHook,
  pythonOlder,
  libsodium,
  cffi,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.6.0";
  outputs = [
    "out"
    "doc"
  ];
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "pynacl";
    tag = version;
    hash = "sha256-7SDJB2bXn0IGJQi597yehs9epdfmS7slbQ97vFVUkEA=";
  };

  nativeBuildInputs = [ sphinxHook ];

  buildInputs = [ libsodium ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  SODIUM_INSTALL = "system";

  pythonImportsCheck = [ "nacl" ];

  meta = {
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
