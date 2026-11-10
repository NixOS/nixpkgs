{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dbus-signature-pyparsing,
  dbus-python,
  pytestCheckHook,
  hypothesis,
  hs-dbus-signature,
}:

buildPythonPackage rec {
  pname = "into-dbus-python";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "into-dbus-python";
    rev = "v${version}";
    hash = "sha256-9sCJM/nQOxZ+0096iCmIzui0jcDNKT9pFfNlRun25HU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dbus-signature-pyparsing
    dbus-python
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    hs-dbus-signature
  ];

  pythonImportsCheck = [ "into_dbus_python" ];

  meta = {
    description = "Transformer to dbus-python types";
    homepage = "https://github.com/stratis-storage/into-dbus-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
