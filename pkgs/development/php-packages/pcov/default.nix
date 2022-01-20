{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "pcov";

  version = "1.0.11";
  sha256 = "sha256-rSLmTNOvBlMwGCrBQsHDq0Dek0SCzUAPi9dgZBMKwkI=";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "A self contained php-code-coverage compatible driver for PHP.";
    license = licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    maintainers = teams.php.members;
  };
}
