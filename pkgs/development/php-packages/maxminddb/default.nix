{
  buildPecl,
  lib,
  fetchFromGitHub,
  libmaxminddb,
}:
let
  pname = "maxminddb";
  version = "1.13.1";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-rOS6XAap94AtFSZnQO8kEXDRUfr1Y5IhWKRxP6fxSio=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = with lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    teams = [
      teams.helsinki-systems
      teams.php
    ];
  };
}
