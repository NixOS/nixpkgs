{ mkXfceDerivation, tzdata, exo, garcon, gtk2, gtk3, glib, gettext, glib-networking, libxfce4ui, libxfce4util, libwnck3, xfconf, gobject-introspection }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.14.3";

  sha256 = "0h8cqs2bghmyp0jihjm2wc7j14k271j178vllin271xrl7kzmvzv";

  nativeBuildInputs = [ gobject-introspection ];
  buildInputs = [ exo garcon gtk2 gtk3 glib glib-networking libxfce4ui libxfce4util libwnck3 xfconf ];

  patches = [ ./xfce4-panel-datadir.patch ];
  patchFlags = [ "-p1" ];

  postPatch = ''
    for f in $(find . -name \*.sh); do
      substituteInPlace $f --replace gettext ${gettext}/bin/gettext
    done
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  configureFlags = [ "--enable-gtk3" ];

  meta =  {
    description = "Xfce's panel";
  };
}
