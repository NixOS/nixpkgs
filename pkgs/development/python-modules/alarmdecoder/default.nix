{ lib, buildPythonPackage, fetchFromGitHub, pyserial, pyftdi, pyusb
, pyopenssl, nose, isPy3k, pythonOlder, mock }:

buildPythonPackage rec {
  pname = "alarmdecoder";
  version = "1.13.10";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nutechsoftware";
    repo = "alarmdecoder";
    rev = version;
    sha256 = "05581j78181p6mwbfpbkp5irnrzsvps1lslgqrh7xbdcmz5b2nxd";
  };

  propagatedBuildInputs = [ pyserial pyftdi pyusb pyopenssl ];

  doCheck = !isPy3k;
  checkInputs = [ nose mock ];
  pythonImportsCheck = [ "alarmdecoder" ];

  meta = with lib; {
    homepage = "https://github.com/nutechsoftware/alarmdecoder";
    description =
      "Python interface for the Alarm Decoder (AD2) family of alarm devices. (AD2USB, AD2SERIAL and AD2PI)";
    license = licenses.mit;
  };
}
