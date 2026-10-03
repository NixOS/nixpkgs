{
  buildPecl,
  lib,
  fetchFromGitHub,
  libmaxminddb,
}:
let
  pname = "maxminddb";
  version = "1.14.0";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-2ooq36ylpS+RchgyLc1N+q20ona+j8Rsg27vGSRni5I=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = lib.licenses.asl20;
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    maintainers = with lib.maintainers; [ helsinki-Jo ];
    teams = [ lib.teams.php ];
  };
}
