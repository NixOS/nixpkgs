{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyparsing,
  pytestCheckHook,
  hypothesis,
  hs-dbus-signature,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-signature-pyparsing";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "dbus-signature-pyparsing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jfqZCLmBW3VxTot1nA5NNTYK4sS4t2iKjB+DisOfK0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];
  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    hs-dbus-signature
  ];

  pythonImportsCheck = [ "dbus_signature_pyparsing" ];

  meta = {
    description = "Parser for a D-Bus Signature";
    homepage = "https://github.com/stratis-storage/dbus-signature-pyparsing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
