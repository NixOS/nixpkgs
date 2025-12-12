{
  buildPecl,
  lib,
  fetchFromGitHub,
  libmaxminddb,
}:
let
  pname = "maxminddb";
  version = "1.12.1";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-VsQOztF4TN3XgJjf3mZa1/Y5+6ounbkLRAzawLSX+BI=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    teams = [
      lib.teams.helsinki-systems
      lib.teams.php
    ];
  };
}
