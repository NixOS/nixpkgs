{ buildPecl, lib, fetchFromGitHub, libmaxminddb }:
let
  pname = "maxminddb";
  version = "1.10.1";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    rev = "v${version}";
    sha256 = "1m5y733x4ykldi1pym54mdahfwfnwy2r1n6fnndwi8jz9px9pa5k";
  };

  buildInputs = [ libmaxminddb ];
  sourceRoot = "source/ext";

  meta = with lib; {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.php.members;
  };
}
