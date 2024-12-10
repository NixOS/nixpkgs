{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  breeze-icons,
  hicolor-icon-theme,
  pantheon,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "luna-icons";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "sha256-zxaay4hwKgb9WWhPNG/s9JekltAvRNYmObeoTJi6Po0=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    hicolor-icon-theme
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Luna* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Icon pack based on marwaita and papirus icons";
    homepage = "https://github.com/darkomarko42/Luna-Icons";
    license = [ licenses.gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
