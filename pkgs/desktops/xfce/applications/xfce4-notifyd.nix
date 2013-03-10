{ stdenv, fetchurl, pkgconfig, intltool
, gtk , libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-notifyd";
  ver_maj = "0.2";
  ver_min = "2";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0s4ilc36sl5k5mg5727rmqims1l3dy5pwg6dk93wyjqnqbgnhvmn";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfce4ui xfconf ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    # to be able to run the daemon we need it in PATH
    cp -l $out/lib/xfce4/notifyd/xfce4-notifyd $out/bin
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "Notification daemon for Xfce";
    license = "GPLv2+";
  };
}
