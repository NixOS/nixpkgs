{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "pcov";

  version = "1.0.9";
  sha256 = "0q2ig5lxzpwz3qgr05wcyh5jzhfxlygkv6nj6jagkhiialng2710";

  buildInputs = [ pcre' ];

  meta.maintainers = lib.teams.php.members;
}
