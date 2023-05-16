{ buildPecl
, lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPecl {
  pname = "inotify";

  version = "3.0.0";
  sha256 = "sha256-xxt4ZEwBFVecx5T1jnhEFEF1HXgEC52dGiI9Ppwtcj0=";

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Inotify bindings for PHP";
    homepage = "https://github.com/arnaud-lb/php-inotify";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    broken = stdenv.isDarwin; # no inotify support
    description = "Inotify bindings for PHP";
    license = licenses.php301;
    homepage = "https://github.com/arnaud-lb/php-inotify";
    maintainers = teams.php.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
