{ stdenv, buildPythonPackage, python, fetchFromGitHub, six, pycryptodome, chardet, nose, pytest }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20170720";

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = "${version}";
    sha256 = "0vax5k0a8qn8x86ybpzqydk7x3hajsk8b6xf3y610j19mgag6wvs";
  };

  propagatedBuildInputs = [ six pycryptodome chardet ];
  
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

