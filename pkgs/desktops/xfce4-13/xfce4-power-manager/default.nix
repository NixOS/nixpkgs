{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "1x1ssji4v9qp64si38paz15bgsgs1w3hkx080qznnmcxqlg7zpj9";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';
}
