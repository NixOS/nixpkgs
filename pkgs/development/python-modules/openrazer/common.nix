{ lib
, fetchFromGitHub
}: rec {
  version = "3.5.1";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-6YU2tl17LpDZe9pQ1a+B2SGIhqGdwME3Db6umVz7RLc=";
  };

  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
