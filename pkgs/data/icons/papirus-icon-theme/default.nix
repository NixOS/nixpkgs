{ lib, stdenvNoCC, fetchFromGitHub, gtk3, pantheon, breeze-icons, gnome-icon-theme, hicolor-icon-theme, papirus-folders, color ? null }:

stdenvNoCC.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20230901";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    hash = "sha256-FcTNZgCdPlYjpheA3PfZBR3apOkDi4+RafQtXdqchGI=";
  };

  nativeBuildInputs = [ gtk3 papirus-folders ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    mv {,e}Papirus* $out/share/icons

    for theme in $out/share/icons/*; do
      ${lib.optionalString (color != null) "${papirus-folders}/bin/papirus-folders -t $theme -o -C ${color}"}
      gtk-update-icon-cache --force $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Papirus icon theme";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.gpl3Only;
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo fortuneteller2k ];
  };
}
