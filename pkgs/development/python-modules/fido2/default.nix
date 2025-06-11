{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  pyscard,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-45+VkgEi1kKD/aXlWB2VogbnBPpChGv6RmL4aqDTMzs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    pcsc = [ pyscard ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  unittestFlagsArray = [ "-v" ];

  pythonImportsCheck = [ "fido2" ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB";
    homepage = "https://github.com/Yubico/python-fido2";
    changelog = "https://github.com/Yubico/python-fido2/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
