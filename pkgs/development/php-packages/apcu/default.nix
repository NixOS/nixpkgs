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

  patches = lib.optionals (lib.versionAtLeast php.version "8.3") [
    (fetchpatch {
      url = "https://github.com/krakjoe/apcu/commit/c9a29161c68c0faf71046e8f03f6a90900023ded.patch";
      hash = "sha256-B0ZKk9TJy2+sYGs7TEX2KxUiOVawIb+RXNgToU1Fz5I=";
    })
  ];

  buildInputs = [ pcre2 ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [ "REPORT_EXIT_STATUS=1" "NO_INTERACTION=1" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta = with lib; {
    changelog = "https://github.com/krakjoe/apcu/releases/tag/v${version}";
    description = "Userland cache for PHP";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/APCu";
    maintainers = teams.php.members;
  };
}
