{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, glib
, libadwaita
, gtk4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.0.alpha";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Nws5v1RMZf9zKSeBft4zfLihWqNtcIHNuRtZPAQNMZU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    libadwaita
    gtk4
  ];

  mesonFlags = [
    "-Dinstall-examples=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Dock/panel library for GTK 4";
    homepage = "https://gitlab.gnome.org/chergert/libpanel";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
