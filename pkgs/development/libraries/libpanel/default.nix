{ lib
, stdenv
, fetchurl
, ninja
, meson
, pkg-config
, vala
, gobject-introspection
, libxml2
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, dbus
, xvfb-run
, glib
, gtk3
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.0.alpha";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Nws5v1RMZf9zKSeBft4zfLihWqNtcIHNuRtZPAQNMZU=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    vala
    gobject-introspection
    libxml2
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    dbus
    xvfb-run
    glib
  ];

  buildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  doCheck = true;

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Dock/panel library for GTK 4";
    homepage = "https://gitlab.gnome.org/chergert/libpanel";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
