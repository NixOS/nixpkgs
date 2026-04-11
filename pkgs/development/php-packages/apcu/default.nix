{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
}:

let
  version = "5.1.28";
in
buildPecl {
  inherit version;
  pname = "apcu";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v${version}";
    sha256 = "sha256-L8bGSPUuBsZXsJdeY6cVA0DvI2+0wEbNHH6IcfT+cFU=";
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
  };
}
