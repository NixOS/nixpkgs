{ lib
, buildPythonPackage
, fetchFromGitHub
, chardet
, dnspython
, html5-parser
, lxml
, namedlist
, sqlalchemy
, tornado
, yapsy
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "ludios_wpull";
  version = "3.0.9";

  # https://github.com/ArchiveTeam/ludios_wpull/issues/20
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "ludios_wpull";
    sha256 = "0j4dir0dgg8pkf4d1znicz6wyyi1wzij50r21z838cycsdr54j4c";
  };

  propagatedBuildInputs = [ chardet dnspython html5-parser lxml namedlist sqlalchemy tornado yapsy ];

  # Test suite has tests that fail on all platforms
  doCheck = false;

  meta = {
    description = "Web crawler; fork of wpull used by grab-site";
    homepage = "https://github.com/ArchiveTeam/ludios_wpull";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ivan ];
    broken = lib.versions.major tornado.version != "4";
  };
}
