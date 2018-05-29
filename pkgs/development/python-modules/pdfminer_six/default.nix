{ stdenv, buildPythonPackage, fetchFromGitHub, six, pycryptodome, chardet, nose, pytest }:

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
    # some crappy hack to ensure the test do not fail for python3
    # for some reason importing from the folder tools fails :\
    cp tools/dumppdf.py tests/
    cp tools/pdf2txt.py tests/
    sed -i '/from tools import dumppdf/c\    import dumppdf' tests/test_tools_dumppdf.py
    sed -i '/import tools.pdf2txt as pdf2txt/c\import pdf2txt as pdf2txt' tests/test_tools_pdf2txt.py
    pytest
  '';

  meta = with stdenv.lib; {
    description = "fork of PDFMiner using six for Python 2+3 compatibility";
    homepage = https://github.com/pdfminer/pdfminer.six;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

