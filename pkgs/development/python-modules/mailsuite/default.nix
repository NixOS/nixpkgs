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
  version = "1.9.14";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8vybabJPQyR0XMXaNp8lQFyuPajrhucgdfazt2ci8Gs=";
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
