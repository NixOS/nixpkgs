{ buildPythonPackage
, fetchPypi
, isPy3k
, lib

# pythonPackages
, dnspython
, html2text
, mail-parser
, IMAPClient
}:

buildPythonPackage rec {
  pname = "mailsuite";
  version = "1.6.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17bsnfjjzv8hx5h397p5pa92l6cqc53i0zjjz2p7bjj3xqzhs45a";
  };

  propagatedBuildInputs = [
    dnspython
    html2text
    mail-parser
    IMAPClient
  ];

  meta = {
    description = "A Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
