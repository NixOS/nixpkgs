{
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  lib,

  # pythonPackages
  hatchling,
  dnspython,
  expiringdict,
  html2text,
  mail-parser,
  imapclient,
  publicsuffix2,
}:

buildPythonPackage rec {
  pname = "mailsuite";
  version = "1.9.16";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rfavOOivttXXmdA/Nl3jUmXIUQrjxDDZ8cHcNIJQL6U=";
  };

  nativeBuildInputs = [ hatchling ];

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
    description = "Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
