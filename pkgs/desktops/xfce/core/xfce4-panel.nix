{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libxfce4ui_gtk3, libwnck, exo, garcon, xfconf, libstartup_notification
, makeWrapper, xfce4-mixer, hicolor-icon-theme, tzdata
, withGtk3 ? false, gtk3, gettext, glib-networking
}:
let
  inherit (stdenv.lib) optional;
  p_name  = "xfce4-panel";
  ver_maj = "4.12";
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1s8cvsrgmkmmm84g6mghpj2k4777gm22g5lrsf8pdy5qh6xql1a2";
  };

  patches = [ ./xfce4-panel-datadir.patch ];
  patchFlags = "-p1";

  postPatch = ''
    for f in $(find . -name \*.sh); do
      substituteInPlace $f --replace gettext ${gettext}/bin/gettext
    done
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
       --replace "if (!g_file_test (filename, G_FILE_TEST_IS_SYMLINK))" ""
  '';

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      garcon xfconf libstartup_notification makeWrapper hicolor-icon-theme
    ] ++ xfce4-mixer.gst_plugins
      ++ optional withGtk3 gtk3;

  propagatedBuildInputs = [ (if withGtk3 then libxfce4ui_gtk3 else libxfce4ui) ];

  configureFlags = optional withGtk3 "--enable-gtk3";

  postInstall = ''
    wrapProgram "$out/bin/xfce4-panel" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.xfce.org/projects/xfce4-panel;
    description = "Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
