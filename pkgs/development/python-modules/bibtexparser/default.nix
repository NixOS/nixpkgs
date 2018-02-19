{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, future
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.0.1";

  # PyPI tarball does not ship tests
  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0lmlarkfbq2hp1wa04a62245jr2mqizqsdlgilj5aq6vy92gr6ai";
  };

  propagatedBuildInputs = [ pyparsing future ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Bibtex parser for python 2.7 and 3.3 and newer";
    homepage = https://github.com/sciunto-org/python-bibtexparser;
    license = with lib.licenses; [ gpl3 bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
