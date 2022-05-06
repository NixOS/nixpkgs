{ lib
, stdenv
, fetchFromGitHub
, gtk3
, breeze-icons
, hicolor-icon-theme
, pantheon
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "luna-icons";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "sha256-aNN7ZoD4hZTw39Rwef4HRHzNzCM6O8Ev+37jZOfzN7s=";
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

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "Icon pack based on marwaita and papirus icons";
    homepage = "https://github.com/darkomarko42/Luna-Icons";
    license = [ licenses.gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
