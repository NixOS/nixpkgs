{
  buildPecl,
  lib,
  fetchFromGitHub,
  libmaxminddb,
}:
let
  pname = "maxminddb";
  version = "1.12.0";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-zFO77h++OHxnk0Rz61jiCBZS80g0+GmRbw2LxayIFuo=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = with lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    maintainers = teams.helsinki-systems.members ++ teams.php.members;
  };
}
