{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  gpib-ctypes,
  pyserial,
  pyusb,
  pyvisa,
  typing-extensions,
  psutil,
  zeroconf,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyvisa-py";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    tag = version;
    hash = "sha256-fXLT3W48HQ744LkwZn784KKmUE8gxDCR+lkcL9xX45g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyvisa
    typing-extensions
  ];

  optional-dependencies = {
    gpib-ctypes = [ gpib-ctypes ];
    serial = [ pyserial ];
    usb = [ pyusb ];
    psutil = [ psutil ];
    hislip-discovery = [ zeroconf ];
    # vicp = [ pyvicp zeroconf ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Module that implements the Virtual Instrument Software Architecture";
    homepage = "https://github.com/pyvisa/pyvisa-py";
    changelog = "https://github.com/pyvisa/pyvisa-py/blob/${src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvnetbiz ];
  };
}
