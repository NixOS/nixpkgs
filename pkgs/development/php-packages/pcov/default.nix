{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "pcov";

  version = "1.0.10";
  sha256 = "sha256-M0oPauqLPNR8QmcGHxR9MDP9rd0vj2iLMj6Wlm2a+Zw=";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "A self contained php-code-coverage compatible driver for PHP.";
    license = licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    maintainers = teams.php.members;
  };
}
