{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2023-03-20";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "8481714cf9ed5148694f1916ceba8fe21e14937b";
    sha256 = "NO12ku8wnW/qMHKxi5TL/dqBxH0+cZbe+fU0iicb9JU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    rm -rf README.md LICENSE icons extra
    cp -r themes/* $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Everforest theme for GTK based desktop environments";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.OulipianSummer ];
  };
}
