{ buildPecl, lib, fetchFromGitHub, php }:
let
  pname = "pinba";

  isPhp73 = lib.versionAtLeast php.version "7.3";

  version = if isPhp73 then "1.1.2-dev" else "1.1.1";

  src = fetchFromGitHub ({
    owner = "tony2001";
    repo = "pinba_extension";
  } // (if (isPhp73) then {
    rev = "edbc313f1b4fb8407bf7d5acf63fbb0359c7fb2e";
    sha256 = "02sljqm6griw8ccqavl23f7w1hp2zflcv24lpf00k6pyrn9cwx80";
  } else {
    rev = "RELEASE_1_1_1";
    sha256 = "1kdp7vav0y315695vhm3xifgsh6h6y6pny70xw3iai461n58khj5";
  }));
in
buildPecl {
  inherit pname version src;

  meta = with lib; {
    description = "PHP extension for Pinba";
    longDescription = ''
      Pinba is a MySQL storage engine that acts as a realtime monitoring and
      statistics server for PHP using MySQL as a read-only interface.
    '';
    homepage = "http://pinba.org/";
    maintainers = teams.php.members;
  };
}
