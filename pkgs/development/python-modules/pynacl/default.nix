{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
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

  src = fetchPypi {
    inherit version;
    pname = "pynacl";
    hash = "sha256-yzber+bivOOyhuXR8+HCRuDM24gI3bRVC7J5Ly3ymPI=";
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
    maintainers = [ ];
  };
}
