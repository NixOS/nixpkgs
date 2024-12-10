{
  lib,
  mkXfceDerivation,
  fetchpatch2,
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
  version = "0.6.2";
  odd-unstable = false;

  sha256 = "sha256-A4siNxbTf9ObJJg8inPuH7Lo4dckLbFljV6aPFQxRto=";

  patches = [
    # shortcuts-plugin: Fix shortcuts-editor include
    # https://gitlab.xfce.org/apps/mousepad/-/merge_requests/131
    (fetchpatch2 {
      url = "https://gitlab.xfce.org/apps/mousepad/-/commit/d2eb43ae4d692cc4753647111eb3deebfa26abbb.patch";
      hash = "sha256-Ldn0ZVmCzqG8lOkeaazkodEMip3lTm/lJEhfsL8TyT8=";
    })
  ];

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
