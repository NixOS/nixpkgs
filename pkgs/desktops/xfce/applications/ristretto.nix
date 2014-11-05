{ stdenv, fetchurl, pkgconfig, intltool, libexif, gtk
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf
, hicolor_icon_theme, makeWrapper
}:

stdenv.mkDerivation rec {
  p_name  = "ristretto";
  ver_maj = "0.6";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0y9d8w1plwp4vmxs44y8k8x15i0k0xln89k6jndhv6lf57g1cs1b";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool libexif gtk dbus_glib exo libxfce4util
      libxfce4ui xfconf hicolor_icon_theme makeWrapper
    ];

  postInstall = ''
    wrapProgram "$out/bin/ristretto" \
      --prefix XDG_DATA_DIRS : "${hicolor_icon_theme}/share"
  '';

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
