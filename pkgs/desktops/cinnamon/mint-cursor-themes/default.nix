{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-cursor-themes";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
    rev = "e17f8a4620827235dabbe5221bd0ee8c44dad0d5";
    hash = "sha256-yLUmIVh884uDVkNil7qxf6t/gykipzBvPgzwmY3zvQk=";
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
