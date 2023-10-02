{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation {
  pname = "everforest-gtk";
  version = "2023.03.20";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "8481714cf9ed5148694f1916ceba8fe21e14937b";
    sha256 = "sha256-NO12ku8wnW/qMHKxi5TL/dqBxH0+cZbe+fU0iicb9JU=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "Everforest colour palette for GTK";
    homepage = "https://www.gnome-look.org/p/1695467";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ jn-sena ];
  };
}
