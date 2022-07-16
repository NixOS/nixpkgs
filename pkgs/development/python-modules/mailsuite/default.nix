{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib

# pythonPackages
, dnspython
, html2text
, mail-parser
, imapclient
}:

buildPythonPackage rec {
  pname = "mailsuite";
  version = "1.8.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ItGOHnYL5rJvllcU/xAie95f09TnCf4OF4Y9oN65FTY=";
  };

  propagatedBuildInputs = [
    dnspython
    html2text
    mail-parser
    imapclient
  ];

  pythonImportsCheck = [ "mailsuite" ];

  meta = {
    description = "A Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
