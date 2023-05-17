{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libxslt
, docbook-xsl-ns
, glib
, gdk-pixbuf
, gnome
, buildPackages
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.8.2";

  outputs = [ "out" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "xfTtPR+G5bEYx2QVqsuGGHPtPm8MazGBuCjPWE/FxhY=";
  };

  mesonFlags = [
    # disable tests as we don't need to depend on GTK (2/3)
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxslt
    docbook-xsl-ns
    glib # for glib-mkenums needed during the build
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that sends desktop notifications to a notification daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libnotify";
    license = licenses.lgpl21;
    maintainers = teams.gnome.members;
    mainProgram = "notify-send";
    platforms = platforms.unix;
  };
}
