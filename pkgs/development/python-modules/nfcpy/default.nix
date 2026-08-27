{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libusb1,
  mock,
  ndeflib,
  pydes,
  pyserial,
  pytest-tornasync,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nfcpy";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nfcpy";
    repo = "nfcpy";
    tag = "v${version}";
    hash = "sha256-HFWOCiz6ISfxEeC6KPKNKGZoHvFjFGUn7QJWnwvJKYw=";
  };

  propagatedBuildInputs = [
    libusb1
    ndeflib
    pydes
    pyserial
  ];

  nativeCheckInputs = [
    pytest-tornasync
    mock
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nfc" ];

  disabledTestPaths = [
    # AttributeError: 'NoneType' object has no attribute 'EC_KEY'
    "tests/test_llcp_llc.py"
    "tests/test_llcp_sec.py"
    # Doesn't work on Hydra
    "tests/test_clf_udp.py"
  ];

  meta = {
    description = "Python module to read/write NFC tags or communicate with another NFC device";
    homepage = "https://github.com/nfcpy/nfcpy";
    changelog = "https://github.com/nfcpy/nfcpy/blob/v${version}/HISTORY.rst";
    license = lib.licenses.eupl11;
    maintainers = with lib.maintainers; [ fab ];
  };
}
