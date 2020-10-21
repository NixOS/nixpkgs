{ buildPecl, lib, pkgs }:
let
  pname = "maxminddb";
  version = "1.8.0";
in
buildPecl {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "0cpd8d1xnkxsrf28z25xzgkkf3wc13ia99v8f7hbl7csvnggs7nn";
  };

  buildInputs = [ pkgs.libmaxminddb ];
  sourceRoot = "source/ext";

  meta = with pkgs.lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.php.members;
  };
}
