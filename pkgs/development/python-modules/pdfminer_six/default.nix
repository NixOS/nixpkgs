{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, six, pycryptodome, chardet, nose, sortedcontainers }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20191020";

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "1fqn4ilcscvw6ws9a1yqiprha9d3rgw3d0280clkbk6s4l26wm9h";
  };

  propagatedBuildInputs = [ six pycryptodome sortedcontainers ]
    ++ stdenv.lib.optionals isPy3k [ chardet ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "fork of PDFMiner using six for Python 2+3 compatibility";
    homepage = https://github.com/pdfminer/pdfminer.six;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy marsam ];
  };
}

