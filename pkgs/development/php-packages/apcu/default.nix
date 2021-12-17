{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "apcu";

  version = "5.1.21";
  sha256 = "sha256-EDNTBEhpbufK3shQUPbfUTX7EzAHLvKnRWk5Ks/s+8E=";

  buildInputs = [ pcre2 ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [ "REPORT_EXIT_STATUS=1" "NO_INTERACTION=1" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Userland cache for PHP";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/APCu";
    maintainers = teams.php.members;
  };
}
