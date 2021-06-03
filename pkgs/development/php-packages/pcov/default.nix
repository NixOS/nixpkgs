{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "pcov";

  version = "1.0.8";
  sha256 = "sha256-6rbniyxLIHPW/e+eWZN1qS8F1rOB7ld1N8JKUS1geRQ=";

  buildInputs = [ pcre2 ];

  meta.maintainers = lib.teams.php.members;
}
