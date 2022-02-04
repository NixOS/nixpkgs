{ buildPecl, lib, pcre2, fetchFromGitHub }:

buildPecl rec {
  pname = "apcu";
  version = "5.1.21";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v${version}";
    sha256 = "sha256-NSVCvShjDbeDrBH0EOUD1EwlYVnMODdANvwohE+P7kI=";
  };

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
