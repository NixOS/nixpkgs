{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "apcu";

  version = "5.1.20";
  sha256 = "sha256-uZ1A+v7Ab00TL87lPnUm3b/B0EHqbgThc4nfrSj5w5A=";

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
