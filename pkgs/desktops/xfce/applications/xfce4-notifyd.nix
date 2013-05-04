{ stdenv, fetchurl, pkgconfig, intltool, libnotify
, gtk , libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-notifyd";
  ver_maj = "0.2";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0fx6z89rxs6ypb8bb6l1pg8fdbxn995fgs413sbhnaxjkm6gch6x";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool libnotify gtk libxfce4util libxfce4ui xfconf ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    # to be able to run the daemon we need it in PATH
    ln -rs $out/lib/xfce4/notifyd/xfce4-notifyd $out/bin
  '';

  doCheck = true;

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "Notification daemon for Xfce";
    license = "GPLv2+";
  };
}
