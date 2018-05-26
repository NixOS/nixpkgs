{ stdenv, fetchurl, pkgconfig, intltool, libexif, gtk
, exo, dbus-glib, libxfce4util, libxfce4ui, xfconf
, hicolor-icon-theme, makeWrapper
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
    [ pkgconfig intltool libexif gtk dbus-glib exo libxfce4util
      libxfce4ui xfconf hicolor-icon-theme makeWrapper
    ];

  postInstall = ''
    wrapProgram "$out/bin/ristretto" \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share"
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
