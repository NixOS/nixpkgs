{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "pcov";

  version = "1.0.9";
  sha256 = "0q2ig5lxzpwz3qgr05wcyh5jzhfxlygkv6nj6jagkhiialng2710";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "A self contained php-code-coverage compatible driver for PHP.";
    license = licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    maintainers = teams.php.members;
  };
}
