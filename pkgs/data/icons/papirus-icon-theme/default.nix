{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, pantheon
, breeze-icons
, gnome-icon-theme
, hicolor-icon-theme
, papirus-folders
, color ? null
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20231101";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    hash = "sha256-0ooHuMqGzlMLVTR/u+kCJLibfqTAtq662EG8i3JIzPA=";
  };

  nativeBuildInputs = [
    gtk3
    papirus-folders
  ];

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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Pixel perfect icon theme for Linux";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.gpl3Only;
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo fortuneteller2k ];
  };
}
