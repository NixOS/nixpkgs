{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, setuptools-scm
, gpib-ctypes
, pyserial
, pyusb
, pyvisa
, typing-extensions
, psutil
, zeroconf
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvisa-py";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    rev = "refs/tags/${version}";
    hash = "sha256-zsa4TGDvvPAogOC0ljXC9uwWC9mteldUYprLmwrXNMQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyvisa
    typing-extensions
  ];

  passthru.optional-dependencies = {
    gpib-ctypes = [ gpib-ctypes ];
    serial = [ pyserial ];
    usb = [ pyusb ];
    psutil = [ psutil ];
    hislip-discovery = [ zeroconf ];
    # vicp = [ pyvicp zeroconf ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Module that implements the Virtual Instrument Software Architecture";
    homepage = "https://github.com/pyvisa/pyvisa-py";
    changelog = "https://github.com/pyvisa/pyvisa-py/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
