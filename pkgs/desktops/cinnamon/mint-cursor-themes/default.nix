{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-cursor-themes";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
<<<<<<< HEAD
    rev = "d2c1428b499a347c291dafb13c89699fdbdd4be7";
    hash = "sha256-i2Wf+OKwal9G5hkcAdmGSgX6txu1AHajqqPJdhpJoA0=";
=======
    rev = "e17f8a4620827235dabbe5221bd0ee8c44dad0d5";
    hash = "sha256-yLUmIVh884uDVkNil7qxf6t/gykipzBvPgzwmY3zvQk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-cursor-themes/";
    description = "Linux Mint cursor themes";
    license = licenses.gpl3Plus;
    maintainers = teams.cinnamon.members;
    platforms = platforms.linux;
  };
}
