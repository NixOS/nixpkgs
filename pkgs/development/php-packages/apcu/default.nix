{
  buildPecl,
  lib,
  fetchpatch,
  pcre2,
  fetchFromGitHub,
}:

let
  version = "5.1.23";
in
buildPecl {
  inherit version;
  pname = "apcu";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v${version}";
    sha256 = "sha256-UDKLLCCnYJj/lCD8ZkkDf2WYZMoIbcP75+0/IXo4vdQ=";
  };

  patches = [
    # Fix broken test (apc_entry_002) with PHP 8.4 alpha1
    # See https://github.com/krakjoe/apcu/issues/510
    (fetchpatch {
      url = "https://github.com/krakjoe/apcu/commit/9dad016db50cc46321afec592ea9b49520c1cf13.patch";
      hash = "sha256-8CPUNhEGCVVSXWYridN1+4N4JzCfXZbmUIsPYs/9jfk=";
    })

    # Fix ZTS detection in tests with PHP 8.4
    # https://github.com/krakjoe/apcu/pull/511
    (fetchpatch {
      url = "https://github.com/krakjoe/apcu/commit/15766e615264620427c2db37061ca9614d3b7319.patch";
      hash = "sha256-gbSkx47Uo9E28CfJJj4+3ydcw8cXW9NNN/3FuYYTVPY=";
    })
  ];

  buildInputs = [ pcre2 ];
  doCheck = true;
  checkTarget = "test";
  checkFlagsArray = [
    "REPORT_EXIT_STATUS=1"
    "NO_INTERACTION=1"
  ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    changelog = "https://github.com/krakjoe/apcu/releases/tag/v${version}";
    description = "Userland cache for PHP";
    homepage = "https://pecl.php.net/package/APCu";
    license = licenses.php301;
    maintainers = teams.php.members;
  };
}
