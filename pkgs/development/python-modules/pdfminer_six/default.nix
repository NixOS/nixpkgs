{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, pycryptodome, chardet, nose, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20200517";

  disabled = !isPy3k;

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "00272pxkh6djm37yvlvgd06w7ycf35srwk6n3p58ppw5hgmpkhc2";
  };

  propagatedBuildInputs = [ chardet pycryptodome sortedcontainers ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy marsam ];
  };
}
