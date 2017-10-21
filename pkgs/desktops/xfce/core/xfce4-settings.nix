{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, libglade, xfconf, xorg, libwnck, libnotify, libxklavier, garcon, upower }:
let
  p_name  = "xfce4-settings";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0x35i1cvkqp0hib1knwa58mckdwrfbhaisz4bsx6bbbx385llj7n";
  };

  patches = [ ./xfce4-settings-default-icon-theme.patch ];

  nativeBuildInputs =
    [ pkgconfig intltool
    ];

  buildInputs =
    [ exo gtk libxfce4util libxfce4ui libglade upower xfconf
      xorg.libXi xorg.libXcursor libwnck libnotify libxklavier garcon
    ]; #TODO: optional packages

  configureFlags = [ "--enable-pluggable-dialogs" "--enable-sound-settings" ];

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/projects/xfce4-settings;
    description = "Settings manager for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

