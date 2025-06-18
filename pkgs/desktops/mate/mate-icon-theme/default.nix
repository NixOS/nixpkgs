{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  iconnamingutils,
  librsvg,
  gtk3,
  hicolor-icon-theme,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "lNYHkGDKXfdFQpId5O6ji30C0HVhyRk1bZXeh2+abTo=";
  };

  postPatch = ''
    # configure script does not recognize utils when cross-compiling
    substituteInPlace ./configure \
      --replace-fail 'have_utils=no' 'have_utils=yes'
  '';

  nativeBuildInputs = [
    pkg-config
    gettext
    gtk3 # gtk-update-icon-cache
    iconnamingutils
  ];

  buildInputs = [
    librsvg
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Icon themes from MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.mate ];
  };
}
