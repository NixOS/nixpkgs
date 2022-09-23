{ lib
, python3
, fetchurl
, pkg-config
, gettext
, mate
, gtk3
, glib
, wrapGAppsHook
, gobject-introspection
, mateUpdateScript
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.26.1";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "DyRCmjsDe9BojsTDkdnYeB5Csj7zRfXlCvHnLF7y+jk=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    mate.mate-menus
    python3.pkgs.pygobject3
  ];

  buildInputs = [
    gtk3
    glib
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "MATE Desktop menu editor";
    homepage = "https://github.com/mate-desktop/mozo";
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
