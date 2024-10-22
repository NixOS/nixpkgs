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
    repo = pname;
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

  meta = with lib; {
    description = "Parser for a D-Bus Signature";
    homepage = "https://github.com/stratis-storage/dbus-signature-pyparsing";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
