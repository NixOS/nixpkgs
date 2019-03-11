{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, chardet
, dnspython
, html5-parser
, lxml
, namedlist
, sqlalchemy
, tornado_4
, Yapsy
}:

buildPythonPackage rec {
  pname = "ludios_wpull";
  version = "3.0.7";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "ludios";
    repo = "wpull";
    sha256 = "1j96avm0ynbazypzp766wh26n4qc73y7wgsiqfrdfl6x7rx20wgf";
  };

  propagatedBuildInputs = [ chardet dnspython html5-parser lxml namedlist sqlalchemy tornado_4 Yapsy ];

  # Test suite has tests that fail on all platforms
  doCheck = false;

  meta = {
    description = "Web crawler; fork of wpull used by grab-site";
    homepage = https://github.com/ludios/wpull;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
