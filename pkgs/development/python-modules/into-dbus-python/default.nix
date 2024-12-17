{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dbus-signature-pyparsing,
  dbus-python,
  pytestCheckHook,
  hypothesis,
  hs-dbus-signature,
}:

buildPythonPackage rec {
  pname = "into-dbus-python";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ld/DyhVaDiWUXgqmvSmEHqFW2dcoRNM0O4X5DXE3UtM=";
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
    description = "Transformer to dbus-python types";
    homepage = "https://github.com/stratis-storage/into-dbus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
