{
  buildPecl,
  lib,
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
