{ mkXfceDerivation
, exo
, garcon
, glib
, gobject-introspection
, gtk3
, libdbusmenu-gtk3
, libwnck
, libxfce4ui
, libxfce4util
, tzdata
, vala
, xfconf
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.16.3";

  sha256 = "sha256-PdE64WKdluKfof/l1wTPi7JdpJMYWIvi0yIdpyntsCA=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  buildInputs = [
    exo
    garcon
    libdbusmenu-gtk3
    libxfce4ui
    libwnck
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
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  # Workaround https://bugzilla.xfce.org/show_bug.cgi?id=15825
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "Panel for the Xfce desktop environment";
  };
}
