{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "apcu";

  version = "5.1.18";
  sha256 = "0ayykd4hfvdzk7qnr5k6yq5scwf6rb2i05xscfv76q5dmkkynvfl";

  buildInputs = [ pcre' ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [ "REPORT_EXIT_STATUS=1" "NO_INTERACTION=1" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
