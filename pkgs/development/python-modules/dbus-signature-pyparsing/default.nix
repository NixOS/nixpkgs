{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
  hypothesis,
  hs-dbus-signature,
}:

buildPythonPackage rec {
  pname = "dbus-signature-pyparsing";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "dbus-signature-pyparsing";
    rev = "v${version}";
    hash = "sha256-+jY8kg3jBDpZr5doih3DiyUEcSskq7TgubmW3qdBoZM=";
  };

  propagatedBuildInputs = [ pyparsing ];
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
}
