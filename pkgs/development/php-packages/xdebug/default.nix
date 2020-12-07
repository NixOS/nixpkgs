{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.1";
  sha256 = "1da983crnk7ci3hfvqrb4gn9w364zzyi147wl4yly9d2adqk358b";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
