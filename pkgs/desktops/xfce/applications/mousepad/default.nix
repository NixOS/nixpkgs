{
  lib,
  mkXfceDerivation,
  gobject-introspection,
  glib,
  gtk3,
  gtksourceview4,
  gspell,
  libxfce4ui,
  xfconf,
  enablePolkit ? true,
  polkit,
}:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.6.3";
  odd-unstable = false;

  sha256 = "sha256-L1txMS86lOEE9tOPTIOr1Gh4lwH7krnAeq4f3yS5kN0=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs =
    [
      glib
      gtk3
      gtksourceview4
      gspell
      libxfce4ui # for shortcut plugin
      xfconf # required by libxfce4kbd-private-3
    ]
    ++ lib.optionals enablePolkit [
      polkit
    ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    mainProgram = "mousepad";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
