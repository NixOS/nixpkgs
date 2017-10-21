{ stdenv, fetchurl, pkgconfig, libpulseaudio
, gtk2, libnotify
, keybinder, xfconf
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-volumed-pulse";
  ver_maj = "0.2";
  ver_min = "2";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0xjcs1b6ix6rwj9xgr9n89h315r3yhdm8wh5bkincd4lhz6ibhqf";
  };

  buildInputs =
    [ libpulseaudio gtk2
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
