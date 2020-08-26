{ stdenv
, fetchFromGitHub
, gtk3
, xcursorgen
, papirus-icon-theme
, hicolor-icon-theme
, deepin
}:

stdenv.mkDerivation rec {
  pname = "deepin-icon-theme";
  version = "2020.05.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0b1s6kf0q804zbbghly981wzacy1spi8168shf3x8w95rqj6463p";
  };

  nativeBuildInputs = [
    gtk3
    xcursorgen
  ];

  propagatedBuildInputs = [
    papirus-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  buildTargets = "all hicolor-links";

  postPatch = ''
    # fix: hicolor links should follow the deepin -> bloom naming change
    # https://github.com/linuxdeepin/deepin-icon-theme/pull/24
    substituteInPlace tools/hicolor.links --replace deepin bloom

    substituteInPlace Sea/index.theme --replace Inherits=deepin Inherits=bloom
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -vai bloom* Sea $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    cp -vai usr/share/icons/hicolor $out/share/icons

    runHook postInstall
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Icons for the Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-icon-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
