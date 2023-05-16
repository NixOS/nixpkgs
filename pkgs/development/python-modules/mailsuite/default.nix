{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib

# pythonPackages
, hatchling
, dnspython
, expiringdict
, html2text
, mail-parser
, imapclient
, publicsuffix2
}:

buildPythonPackage rec {
  pname = "mailsuite";
<<<<<<< HEAD
  version = "1.9.15";
=======
  version = "1.9.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-R4nAphydamZojQR7pro5Y3dZg3nYK0+X5lFBMJUpCfw=";
=======
    hash = "sha256-8vybabJPQyR0XMXaNp8lQFyuPajrhucgdfazt2ci8Gs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    dnspython
    expiringdict
    html2text
    mail-parser
    imapclient
    publicsuffix2
  ];

  pythonImportsCheck = [ "mailsuite" ];

  doCheck = false;

  meta = {
    description = "A Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
