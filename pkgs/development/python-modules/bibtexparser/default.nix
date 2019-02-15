{ lib
, buildPythonPackage, fetchFromGitHub
, future, pyparsing
, nose, unittest2
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.1.0";

  # PyPI tarball does not ship tests
  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "1yj3hqnmkjh0sjjhmlm4097mmz98kna8rn0dd9g8zaw9g1a35h8c";
  };

  propagatedBuildInputs = [ future pyparsing ];

  checkInputs = [ nose unittest2  ];

  checkPhase = ''
  '';

  meta = {
    description = "Bibtex parser for python 2.7 and 3.3 and newer";
    homepage = https://github.com/sciunto-org/python-bibtexparser;
    license = with lib.licenses; [ gpl3 bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
