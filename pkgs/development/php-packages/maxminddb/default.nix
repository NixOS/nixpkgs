{ buildPecl, lib, pkgs }:
let
  pname = "maxminddb";
  version = "1.10.0";
in
buildPecl {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "sha256-2SnajDdO5uAYcuVpEbOuFlZzMxwo/EqFtUSr9XxT0KQ=";
  };

  buildInputs = [ pkgs.libmaxminddb ];
  sourceRoot = "source/ext";

  meta = with pkgs.lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.php.members;
  };
}
