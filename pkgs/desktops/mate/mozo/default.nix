{
  lib,
  python3,
  fetchurl,
  pkg-config,
  gettext,
  mate-menus,
  gtk3,
  glib,
  wrapGAppsHook3,
  gobject-introspection,
  mateUpdateScript,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.28.0";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "/piYT/1qqMNtBZS879ugPeObQtQeAHJRaAOE8870SSQ=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    mate-menus
    python3.pkgs.pygobject3
  ];

  buildInputs = [
    gtk3
    glib
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE Desktop menu editor";
    mainProgram = "mozo";
    homepage = "https://github.com/mate-desktop/mozo";
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
