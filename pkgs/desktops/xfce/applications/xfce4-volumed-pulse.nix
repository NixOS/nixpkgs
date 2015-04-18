{ stdenv, fetchurl, pkgconfig, pulseaudio
, gtk2, libnotify
, keybinder, xfconf
}:

stdenv.mkDerivation rec {
  version = "0.2.0";
  name = "xfce4-volumed-pulse-${version}";

  src = fetchurl {
    url = "https://launchpad.net/xfce4-volumed-pulse/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0l75gl96skm0zn10w70mwvsjd12p1zjshvn7yc3439dz61506c39";
  };

  buildInputs =
    [ pulseaudio gtk2
      keybinder xfconf libnotify
    ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/xfce4-volumed-pulse;
    description = "A volume keys control daemon for the Xfce desktop environment (Xubuntu fork)";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
