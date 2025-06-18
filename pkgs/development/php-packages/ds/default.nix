{
  buildPecl,
  lib,
  pcre2,
  php,
  fetchFromGitHub,
}:

let
  version = "1.6.0";
in
buildPecl {
  inherit version;
  pname = "ds";

  src = fetchFromGitHub {
    owner = "php-ds";
    repo = "ext-ds";
    rev = "v${version}";
    sha256 = "sha256-c7MIqaPwIgdzKHRqR2km1uTQRrrr3OzDzopTbz5rLnE=";
  };

  buildInputs = [ pcre2 ];

  meta = with lib; {
    changelog = "https://github.com/php-ds/ext-ds/releases/tag/v${version}";
    description = "Extension providing efficient data structures for PHP";
    license = licenses.mit;
    homepage = "https://github.com/php-ds/ext-ds";
    teams = [ teams.php ];
  };
}
