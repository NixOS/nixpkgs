{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "1n9i62jh5ldf8g9n64mm6nh1182abbf96444j14dppb82r94q077";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';
}
