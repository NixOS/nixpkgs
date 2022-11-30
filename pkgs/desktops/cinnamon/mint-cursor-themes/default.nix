{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-cursor-themes";
  version = "unstable-2022-11-29";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = "aa6bb767831ac43d1768c2e639de713a4a1eba8d";
    hash = "sha256-UQnRrylUo9zuDiAwQ1COtXMtq4XTbxtMle41p+pzxJc=";
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
