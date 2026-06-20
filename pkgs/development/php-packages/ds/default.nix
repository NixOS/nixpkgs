{
  buildPecl,
  lib,
  pcre2,
  php,
  fetchFromGitHub,
}:

let
  version = "2.0.0";
in
buildPecl {
  inherit version;
  pname = "ds";

  src = fetchFromGitHub {
    owner = "php-ds";
    repo = "ext-ds";
    rev = "v${version}";
    sha256 = "sha256-QWBxjt3rzD3m3y2ScbYvtZnjPUYsd3uMMQOFY/RQ3Io=";
  };

  buildInputs = [ pcre2 ];

  meta = {
    changelog = "https://github.com/php-ds/ext-ds/releases/tag/v${version}";
    description = "Extension providing efficient data structures for PHP";
    license = lib.licenses.mit;
    homepage = "https://github.com/php-ds/ext-ds";
    teams = [ lib.teams.php ];
  };
}
