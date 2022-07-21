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
  version = "1.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UV9cdWdUnUt4j1Puf1H0UxXsCHi3t4uNiKHwYNfTfa4=";
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
