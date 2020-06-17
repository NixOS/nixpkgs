{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "1.6.6";

  sha256 = "0lyp3dp4ijbpf21vanrvgm6rmfp8v0zyqxibdj5gxnadmvcq38iy";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';

  meta = {
    description = "A power manager for the Xfce Desktop Environment";
  };
}
