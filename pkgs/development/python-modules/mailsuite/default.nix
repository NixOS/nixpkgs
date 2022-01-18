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
  version = "1.6.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17bsnfjjzv8hx5h397p5pa92l6cqc53i0zjjz2p7bjj3xqzhs45a";
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
