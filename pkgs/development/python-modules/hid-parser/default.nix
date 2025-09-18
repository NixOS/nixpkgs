{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "hid-parser";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usb-tools";
    repo = "python-hid-parser";
    tag = version;
    hash = "sha256-8aGyLTsBK5etwbqFkNinbLHCt20fsQEmuBvu3RrwCDA=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "hid_parser" ];

  meta = with lib; {
    description = "Typed pure Python library to parse HID report descriptors";
    homepage = "https://github.com/usb-tools/python-hid-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
