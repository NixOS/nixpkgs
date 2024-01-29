{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, breeze-icons
, elementary-icon-theme
, hicolor-icon-theme
, papirus-folders
, color ? null
, withElementary ? false
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20231201";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    hash = "sha256-nLc2nt8YI193loMHjzzEwgvb+tdNrVTZskqssX2oFrU=";
  };

  nativeBuildInputs = [
    gtk3
    papirus-folders
  ];

  propagatedBuildInputs = [
    breeze-icons
    hicolor-icon-theme
  ] ++ lib.optional withElementary [
    elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv ${lib.optionalString withElementary "{,e}"}Papirus* $out/share/icons

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
    maintainers = with maintainers; [ romildo moni ];
  };
}
