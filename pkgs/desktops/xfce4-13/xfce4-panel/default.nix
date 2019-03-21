{ mkXfceDerivation, makeWrapper, tzdata, exo, garcon, gtk2, gtk3, gettext, glib-networking, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.13.4";

  sha256 = "13hnzh31d2b1331lnsbfaxg4fqhqa7hmdwkiqsl9hyr8pqimjb2g";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ exo garcon gtk2 gtk3 libxfce4ui libxfce4util libwnck3 xfconf ];

  patches = [ ../../xfce/core/xfce4-panel-datadir.patch ];
  patchFlags = "-p1";

  postPatch = ''
    for f in $(find . -name \*.sh); do
      substituteInPlace $f --replace gettext ${gettext}/bin/gettext
    done
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
       --replace "if (!g_file_test (filename, G_FILE_TEST_IS_SYMLINK))" ""
  '';

  configureFlags = [ "--enable-gtk3" ];

  postInstall = ''
    wrapProgram "$out/bin/xfce4-panel" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
  '';

  meta =  {
    description = "Xfce's panel";
  };
}
