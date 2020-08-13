{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, cryptography, chardet, nose, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20200720";

  disabled = !isPy3k;

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "19cnl1b6mrk9i18a1k4vdl5k85ww8yhfq89w3fxh6rb0fla5d71i";
  };

  propagatedBuildInputs = [ chardet cryptography sortedcontainers ];

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
