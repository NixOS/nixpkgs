{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, garcon, libxfce4util
, libxfce4ui, xfconf, libXi, upower ? null, libnotify ? null
, libXcursor ? null, xf86inputlibinput ? null, libxklavier ? null }:

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

  postPatch = ''
    for f in $(find . -name \*.c); do
      substituteInPlace $f --replace \"libinput-properties.h\" '<xorg/libinput-properties.h>'
    done
  '';

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [
    exo
    gtk
    garcon
    libxfce4util
    libxfce4ui
    xfconf
    libXi
    upower
    libnotify
    libXcursor
    xf86inputlibinput
    libxklavier
  ];

  configureFlags = [ "--enable-pluggable-dialogs" "--enable-sound-settings" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.xfce.org/projects/xfce4-settings;
    description = "Settings manager for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
