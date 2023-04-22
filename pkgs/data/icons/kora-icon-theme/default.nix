{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, adwaita-icon-theme
, breeze-icons
, hicolor-icon-theme
, gitUpdater
}:

stdenvNoCC.mkDerivation rec  {
  pname = "kora-icon-theme";
  version = "1.5.6";

  src = fetchFromGitHub  {
    owner = "bikass";
    repo = "kora";
    rev = "v${version}";
    sha256 = "sha256-vAeml+upESUVlJ95Rm0+vlZ+NQZWEZl00scDkb3W7Yo=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a kora* $out/share/icons/
    rm $out/share/icons/kora*/create-new-icon-theme.cache.sh

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache -f $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "An SVG icon theme in four variants";
    homepage = "https://github.com/bikass/kora";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
