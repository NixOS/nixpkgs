{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  pyscard,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8TefhFhwzH/GTH8HMjw85B6MlsNwVOeeCs1WMLP+xaw=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    pcsc = [ pyscard ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-v"
    "--no-device"
  ];

  pythonImportsCheck = [ "fido2" ];

  meta = {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB";
    homepage = "https://github.com/Yubico/python-fido2";
    changelog = "https://github.com/Yubico/python-fido2/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
