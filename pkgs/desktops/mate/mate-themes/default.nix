{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  mate-icon-theme,
  gtk2,
  gtk3,
  gtk_engines,
  gtk-engine-murrine,
  gdk-pixbuf,
  librsvg,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-themes";
  version = "3.22.26";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/themes/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Ik6J02TrO3Pxz3VtBUlKmEIak8v1Q0miyF/GB+t1Xtc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gtk3
  ];

  buildInputs = [
    mate-icon-theme
    gtk2
    gtk_engines
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      lgpl21Plus
      lgpl3Only
      gpl3Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
