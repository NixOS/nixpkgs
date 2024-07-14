{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  sphinxHook,
  pythonOlder,
  libsodium,
  cffi,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.5.0";
  outputs = [
    "out"
    "doc"
  ];
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    hash = "sha256-isdEjwmrhYEWB73SHsJGRJWsi3xm0Ua/VFsPCPuSILo=";
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

  meta = with lib; {
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
