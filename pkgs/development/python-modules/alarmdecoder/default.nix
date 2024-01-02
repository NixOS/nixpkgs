{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pyftdi
, pyopenssl
, pyserial
, pytestCheckHook
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "alarmdecoder";
  version = "1.13.11";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nutechsoftware";
    repo = "alarmdecoder";
    rev = version;
    hash = "sha256-q2s+wngDKtWm5mxGHNAc63Ed6tiQD9gLHVoQZNWFB0w=";
  };

  propagatedBuildInputs = [
    pyftdi
    pyopenssl
    pyserial
    pyusb
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Socket issue, https://github.com/nutechsoftware/alarmdecoder/issues/45
    "test_ssl"
    "test_ssl_exception"
  ];

  pythonImportsCheck = [ "alarmdecoder" ];

  meta = with lib; {
    description = "Python interface for the Alarm Decoder (AD2USB, AD2SERIAL and AD2PI) devices";
    homepage = "https://github.com/nutechsoftware/alarmdecoder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
