{ buildPecl, lib, pcre2, php, fetchFromGitHub }:

let
  version = "1.4.0";
in buildPecl {
  inherit version;
  pname = "ds";

  src = fetchFromGitHub {
    owner = "php-ds";
    repo = "ext-ds";
    rev = "v${version}";
    sha256 = "sha256-IqNv2jVW1Hg1hV8H9vEyLT5BWsFkGHR+WlAOHJhlW84=";
  };

  buildInputs = [ pcre2 ];

  meta = with lib; {
    changelog = "https://github.com/php-ds/ext-ds/releases/tag/v${version}";
    description = "An extension providing efficient data structures for PHP";
    license = licenses.mit;
    homepage = "https://github.com/php-ds/ext-ds";
    maintainers = teams.php.members;
  };
}
