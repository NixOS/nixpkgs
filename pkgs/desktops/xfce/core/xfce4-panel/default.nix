{ mkXfceDerivation
, exo
, garcon
, gettext
, glib
, gobject-introspection
, gtk3
, libdbusmenu-gtk3
, libwnck3
, libxfce4ui
, libxfce4util
, tzdata
, vala
, xfconf
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.16.2";

  sha256 = "0wy66viwjnp1c0lgf90fp3vyqy0f1m1kbfdym8a0yrv2b6sn3958";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  buildInputs = [
    exo
    garcon
    libdbusmenu-gtk3
    libxfce4ui
    libwnck3
    xfconf
    tzdata
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    libxfce4util
  ];

  patches = [ ./xfce4-panel-datadir.patch ];

  postPatch = ''
    for f in $(find . -name \*.sh); do
      substituteInPlace $f --replace gettext ${gettext}/bin/gettext
    done
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  # Workaround https://bugzilla.xfce.org/show_bug.cgi?id=15825
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "Xfce's panel";
  };
}
