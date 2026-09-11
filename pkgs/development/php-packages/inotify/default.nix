{ buildPecl, lib }:

buildPecl {
  pname = "inotify";

  version = "3.0.1";
  sha256 = "sha256-+7ckCrrlAuqPSzxoJkxkJftGZHQCqPk5FkgoRTlK0SQ=";

  doCheck = true;

  meta = {
    description = "Inotify bindings for PHP";
    homepage = "https://github.com/arnaud-lb/php-inotify";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
    platforms = lib.platforms.linux;
  };
}
