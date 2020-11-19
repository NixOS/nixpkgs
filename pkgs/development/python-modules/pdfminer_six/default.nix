{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, cryptography, chardet, nose, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20201018";

  disabled = !isPy3k;

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "1a2fxxnnjqbx344znpvx7cnv1881dk6585ibw01inhfq3w6yj2lr";
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
