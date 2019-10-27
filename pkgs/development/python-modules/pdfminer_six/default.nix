{ stdenv, buildPythonPackage, python, fetchFromGitHub, six, pycryptodome, chardet, nose, pytest, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20181108";

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "1v8pcx43fgidv1g54s92k85anvcss08blkhm4yi1hn1ybl0mmw6c";
  };

  propagatedBuildInputs = [ six pycryptodome chardet sortedcontainers ];

  checkInputs = [ nose pytest ];
  checkPhase = ''
    ${python.interpreter} -m pytest
  '';

  meta = with stdenv.lib; {
    description = "fork of PDFMiner using six for Python 2+3 compatibility";
    homepage = https://github.com/pdfminer/pdfminer.six;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

