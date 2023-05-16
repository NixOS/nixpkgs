{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "illwill";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "johnnovak";
    repo = "illwill";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4DHGVWzN/WTAyDRBBpXlcfKnYIcbFt42/iWInaBUwi4=";
=======
    hash = "sha256-9YBkad5iUKRb375caAuoYkfp5G6KQDhX/yXQ7vLu/CA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib;
    src.meta // {
      description = "A curses inspired simple cross-platform console library for Nim";
      license = [ licenses.wtfpl ];
      maintainers = with maintainers; [ sikmir ];
    };
}
