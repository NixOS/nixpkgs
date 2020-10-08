{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, cryptography, chardet, nose, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20200726";

  disabled = !isPy3k;

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "1hlaz7ax1czb028x3nhk3l2jy07f26q5hbhmdirljaaga24vd96z";
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
