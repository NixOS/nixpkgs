{ buildPecl, lib, pcre2, php }:

buildPecl {
  pname = "ds";

  version = "1.4.0";
  sha256 = "1vwk5d27zd746767l8cvbcdr8r70v74vw0im38mlw1g85mc31fd9";

  buildInputs = [ pcre2 ];

  internalDeps = lib.optionals (lib.versionOlder php.version "8.0") [ php.extensions.json ];

  meta = with lib; {
    description = "An extension providing efficient data structures for PHP";
    license = licenses.mit;
    homepage = "https://github.com/php-ds/ext-ds";
    maintainers = teams.php.members;
  };
}
