{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "pcov";

  version = "1.0.8";
  sha256 = "sha256-6rbniyxLIHPW/e+eWZN1qS8F1rOB7ld1N8JKUS1geRQ=";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "A self contained php-code-coverage compatible driver for PHP.";
    license = licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    maintainers = teams.php.members;
  };
}
