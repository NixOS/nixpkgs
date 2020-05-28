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
  version = "2020.07.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1549h0jj7l32v1cn1xjxniir52qn2ssi5lnq8pm5k3x8qclihzhq";
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

  postPatch = ''
    # fix: hicolor links should follow the deepin -> bloom naming change
    # https://github.com/linuxdeepin/deepin-icon-theme/pull/24
    substituteInPlace tools/hicolor.links --replace deepin bloom

    # fix: update the parent theme name
    for f in Sea/index.theme bloom-{dark,fantacy}/cursor.theme ; do
      substituteInPlace $f --replace Inherits=deepin Inherits=bloom
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a bloom* Sea $out/share/icons

    # TODO: bloom-classic fails building the cache
    rm -rf $out/share/icons/bloom-classic

    #for theme in $out/share/icons/{bloom{,-dark,-classic,-classic-dark},Sea}; do
    for theme in $out/share/icons/{bloom{,-dark,-classic-dark},Sea}; do
      echo ========= $theme
      gtk-update-icon-cache $theme
    done

    cp -a usr/share/icons/hicolor $out/share/icons

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
