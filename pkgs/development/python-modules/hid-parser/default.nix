{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "hid-parser";
  version = "0.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zbm+h+ieDmd1K0uH+9B8EWtYScxqYJXVpY9bXdBivA4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
