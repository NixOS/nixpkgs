{ buildPecl
, lib
, stdenv
}:

buildPecl {
  pname = "inotify";

  version = "3.0.0";
  sha256 = "sha256-xxt4ZEwBFVecx5T1jnhEFEF1HXgEC52dGiI9Ppwtcj0=";

  doCheck = true;

  meta = with lib; {
    broken = stdenv.isDarwin; # no inotify support
    description = "Inotify bindings for PHP";
    license = licenses.php301;
    homepage = "https://github.com/arnaud-lb/php-inotify";
    maintainers = teams.php.members;
  };
}
