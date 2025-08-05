{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest7CheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "hid-parser";
  version = "0.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5+lt18kXcs8t5SjhIAxA5XHZpSd/9ObgT+gtzhvl25k=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest7CheckHook
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
