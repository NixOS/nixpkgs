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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "mailsuite";
<<<<<<< HEAD
  version = "1.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+QPGSQQZaUjDmTGhZZoyTGegKV9DBqrgnxdQpEgszrI=";
=======
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xYM4/Ou91WtYwiobE9ihlYGu8ViNTVbSLFGi8Y9yPc4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
