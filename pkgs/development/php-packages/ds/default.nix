{ buildPecl, lib, pcre2, php, fetchFromGitHub }:

buildPecl rec {
  pname = "ds";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "php-ds";
    repo = "ext-ds";
    rev = "v${version}";
    sha256 = "sha256-IqNv2jVW1Hg1hV8H9vEyLT5BWsFkGHR+WlAOHJhlW84=";
  };

  buildInputs = [ pcre2 ];

  internalDeps = lib.optionals (lib.versionOlder php.version "8.0") [ php.extensions.json ];

  meta = with lib; {
    description = "An extension providing efficient data structures for PHP";
    homepage = "https://github.com/php-ds/ext-ds";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
}
