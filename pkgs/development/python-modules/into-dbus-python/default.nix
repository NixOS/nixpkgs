{ lib
, buildPythonPackage
, fetchFromGitHub
, dbus-signature-pyparsing
, dbus-python
, pytestCheckHook
, hypothesis
, hs-dbus-signature
}:

buildPythonPackage rec {
  pname = "into-dbus-python";
  version = "0.08";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Z8e6oAvRMIisMjG4HcS5jSH1znGVc7pGpMITo5fXYVs=";
  };

  propagatedBuildInputs = [
    dbus-signature-pyparsing
    dbus-python
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    hs-dbus-signature
  ];

  pythonImportsCheck = [ "into_dbus_python" ];

  meta = with lib; {
    description = "A transformer to dbus-python types";
    homepage = "https://github.com/stratis-storage/into-dbus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
