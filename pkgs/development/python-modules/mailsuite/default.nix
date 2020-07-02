{ stdenv, buildPythonPackage, fetchPypi, python, IMAPClient, html2text, dnspython, mail-parser, six }:

buildPythonPackage rec {
  pname = "mailsuite";
  version = "1.6.0";
  disabled = !python.isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12r2bh9rgivlmk2z2n7rzrx0323ccyn3kgylm17jjrnx670qpmcd";
  };

  propagatedBuildInputs = [ dnspython IMAPClient html2text mail-parser six ];

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "six==1.13.0" "six>=1.13.0" \
      --replace "mail-parser==3.11.0" "mail-parser>=3.11.0"
  '';

  meta = with stdenv.lib; {
    description = "A Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
