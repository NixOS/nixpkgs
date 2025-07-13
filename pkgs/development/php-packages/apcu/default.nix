{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
  php,
}:

let
  version = "5.1.27";
in
buildPecl {
  inherit version;
  pname = "apcu";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    tag = "v${version}";
    hash = "sha256-kf1d+WLpwhzQVn9pnkXtPPTXI5XaAuIAReI6rDGypB8=";
  };

  buildInputs = [ pcre2 ];
  doCheck = true;
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = {
    changelog = "https://github.com/krakjoe/apcu/releases/tag/v${version}";
    description = "Userland cache for PHP";
    homepage = "https://pecl.php.net/package/APCu";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
