{ buildPecl, lib }:

buildPecl {
  pname = "inotify";

  version = "3.0.0";
  sha256 = "sha256-xxt4ZEwBFVecx5T1jnhEFEF1HXgEC52dGiI9Ppwtcj0=";

  doCheck = true;

  meta = {
    description = "Inotify bindings for PHP";
    homepage = "https://github.com/arnaud-lb/php-inotify";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
    platforms = lib.platforms.linux;
  };
}
