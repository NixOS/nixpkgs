{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "apcu";

  version = "5.1.19";
  sha256 = "1q3c4y9jqh1yz5vps2iiz2x04vn0y1g5ibxg1x8zp7n7sncvqzw3";

  buildInputs = [ pcre' ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [ "REPORT_EXIT_STATUS=1" "NO_INTERACTION=1" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
