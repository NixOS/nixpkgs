{ buildPecl, lib, pcre2, fetchFromGitHub, php, fetchpatch }:

let
  version = "5.1.22";
in buildPecl {
  inherit version;
  pname = "apcu";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v${version}";
    sha256 = "sha256-L4a+/kWT95a1Km+FzFNiAaBw8enU6k4ZiCFRErjj9o8=";
  };

  buildInputs = [ pcre2 ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [ "REPORT_EXIT_STATUS=1" "NO_INTERACTION=1" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta = with lib; {
    changelog = "https://github.com/krakjoe/apcu/releases/tag/v${version}";
    description = "Userland cache for PHP";
    homepage = "https://pecl.php.net/package/APCu";
    license = licenses.php301;
    maintainers = teams.php.members;
  };
}
