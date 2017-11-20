{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libxfce4ui_gtk3, libwnck, exo, garcon, xfconf, libstartup_notification
, makeWrapper, xfce4mixer, hicolor_icon_theme
, withGtk3 ? false, gtk3, gettext
}:
let
  inherit (stdenv.lib) optional;
  p_name  = "xfce4-panel";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1s52k80911pkp65zkxw9mrnczxsd81svr0djmmcfpjd9rj08pmck";
  };

  patches = [ ./xfce4-panel-datadir.patch ];
  patchFlags = "-p1";

  postPatch = ''
    for f in $(find . -name \*.sh); do
      substituteInPlace $f --replace gettext ${gettext}/bin/gettext
    done
  '';

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      garcon xfconf libstartup_notification makeWrapper hicolor_icon_theme
    ] ++ xfce4mixer.gst_plugins
      ++ optional withGtk3 gtk3;

  propagatedBuildInputs = [ (if withGtk3 then libxfce4ui_gtk3 else libxfce4ui) ];

  configureFlags = optional withGtk3 "--enable-gtk3";

  postInstall = ''
    wrapProgram "$out/bin/xfce4-panel" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/projects/xfce4-panel;
    description = "Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
