{ lib
, mkXfceDerivation
, exo
, garcon
, gobject-introspection
, gtk3
, libdbusmenu-gtk3
, libwnck
, libxfce4ui
, libxfce4util
, tzdata
, vala
, xfconf
, libxfce4windowing
, gtk-layer-shell
, isNixOS ? true
, lndir
, embedPlugins ? []
}:

assert lib.assertMsg (if isNixOS
                      then (embedPlugins == [])
                      else true) ''
  NixOS does not embed xfce4-panel plugins (use systemPackages instead)
'';

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.19.0";

  sha256 = "sha256-fm3xLNc53QY1H93hOJp5tEPXiP1ZL+a/yQ7p3zTgI58=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  buildInputs = [
    exo
    garcon
    libdbusmenu-gtk3
    libxfce4ui
    libwnck
    xfconf
    tzdata
    libxfce4windowing
    gtk-layer-shell
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
    libxfce4windowing
  ];

  patches = lib.optional isNixOS [ ./xfce4-panel-datadir.patch ];

  postPatch = ''
    substituteInPlace plugins/clock/clock.c \
       --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  inherit embedPlugins;
  passAsFile = [ "embedPlugins" ];
  postInstall = lib.optionalString (embedPlugins != []) ''
    for p in $(cat "$embedPluginsPath"); do
      ${lndir}/bin/lndir "$p" "$out"
    done 2>&1
  '';

  meta = with lib; {
    description = "Panel for the Xfce desktop environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
