{ buildPecl, lib, fetchFromGitHub }:

let
<<<<<<< HEAD
  version = "3.2.2";
=======
  version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zbgJw2oPzyUTK0UwLAqpShBi+toVsEQcjoG4tIBder0=";
=======
    sha256 = "sha256-WKvMnn8yp6JBFu7xzPOt6sdg5JE8SRniLZbSBvi3ecQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
=======
  meta = with lib; {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    license = licenses.php301;
    homepage = "https://xdebug.org/";
    maintainers = teams.php.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
