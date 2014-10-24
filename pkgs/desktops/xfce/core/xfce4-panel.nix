{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, exo, garcon, xfconf, libstartup_notification
, makeWrapper, xfce4mixer }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-panel";
  ver_maj = "4.10";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1mkmhhmy70izja6d6di65hay9ybqi8615pwjbx0lgqk53gnm4c2p";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  patches = [ ./xfce4-panel-datadir.patch ];
  patchFlags = "-p1";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      garcon xfconf libstartup_notification makeWrapper
    ] ++ xfce4mixer.gst_plugins;
  propagatedBuildInputs = [ libxfce4ui ];

  postInstall = ''
    wrapProgram "$out/bin/xfce4-panel" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-panel;
    description = "Xfce panel";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
