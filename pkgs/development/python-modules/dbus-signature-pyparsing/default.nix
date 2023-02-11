{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, pytestCheckHook
, hypothesis
, hs-dbus-signature
}:

buildPythonPackage rec {
  pname = "dbus-signature-pyparsing";
  version = "0.04";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IXyepfq7pLTRkTolKWsKGrYDoxukVC9JTrxS9xV7s2I=";
  };

  propagatedBuildInputs = [ pyparsing ];
  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    hs-dbus-signature
  ];

  pythonImportsCheck = [ "dbus_signature_pyparsing" ];

  meta = with lib; {
    description = "A Parser for a D-Bus Signature";
    homepage = "https://github.com/stratis-storage/dbus-signature-pyparsing";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
