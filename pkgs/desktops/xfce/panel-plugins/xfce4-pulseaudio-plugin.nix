{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4panel_gtk3, xfconf
, gtk3, libpulseaudio, hicolor-icon-theme
, withKeybinder ? true, keybinder3
, withLibnotify ? true, libnotify
}:

assert withKeybinder -> keybinder3 != null;
assert withLibnotify -> libnotify != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  p_name  = "xfce4-pulseaudio-plugin";
  ver_maj = "0.2";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "e82836bc8cf7d905b4e60d43dc630ba8e32dea785989700c71d4aeee9f583b33";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ libxfce4util xfce4panel_gtk3 xfconf gtk3 libpulseaudio hicolor-icon-theme ]
    ++ optional withKeybinder keybinder3
    ++ optional withLibnotify libnotify;

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Adjust the audio volume of the PulseAudio sound system";
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
