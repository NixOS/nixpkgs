{ lib, mkXfceDerivation, gtk3, libnotify, libpulseaudio, keybinder3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-volumed-pulse";
  version = "0.2.3";

  sha256 = "1rsjng9qmq7vzrx5bfxq76h63y501cfl1mksrxkf1x39by9r628j";

  buildInputs = [ gtk3 libnotify libpulseaudio keybinder3 xfconf ];

  meta = with lib; {
    description = "A volume keys control daemon for Xfce using pulseaudio";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.abbradar ];
  };
}
