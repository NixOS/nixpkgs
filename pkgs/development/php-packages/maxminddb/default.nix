{ buildPecl, lib, fetchFromGitHub, libmaxminddb }:
let
  pname = "maxminddb";
  version = "1.11.0";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-Dw1+pYJmZ3U2+rgSOEkx4a6HB8FebSr7YZodOjSipjI=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = with lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.php.members;
  };
}
