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
  version = "1.9.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wgutyXxo1z3GxO3xikRlA4Og+oz+7+PrY2Hs6gicO/o=";
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
