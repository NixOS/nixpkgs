{
  lib,
  buildPythonPackage,
  dnspython,
  expiringdict,
  fetchPypi,
  hatchling,
  html2text,
  imapclient,
  mail-parser,
  publicsuffix2,
}:

buildPythonPackage rec {
  pname = "mailsuite";
  version = "1.11.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ilcOH27lVKhh/xFO/dkWZkwtx6wPYrKTWR3n1xqoUdk=";
  };

  pythonRelaxDeps = [ "mail-parser" ];

  build-system = [ hatchling ];

  dependencies = [
    dnspython
    expiringdict
    html2text
    mail-parser
    imapclient
    publicsuffix2
  ];

  pythonImportsCheck = [ "mailsuite" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    changelog = "https://github.com/seanthegeek/mailsuite/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
