{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  pyscard,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fido2";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hXh0KKlMP46vcvD/MK+6mDtVmhsbeVyTMYyBtK1AYsQ=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    pcsc = [ pyscard ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [
    "-v"
    "--no-device"
  ];

  pythonImportsCheck = [ "fido2" ];

  meta = {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB";
    homepage = "https://github.com/Yubico/python-fido2";
    changelog = "https://github.com/Yubico/python-fido2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
