{ lib
, mkXfceDerivation
, gobject-introspection
, gtk3
, gdk-pixbuf
, libwnck
, wayland
, wayland-protocols
, wayland-scanner}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.19.1";

  sha256 = "sha256-vxdNHDVWBKuyU7JBbjRAsojbwwwl1y5eUSDzJSvUAqw=";

  nativeBuildInputs = [
    gobject-introspection
    wayland
    wayland-protocols
    wayland-scanner
  ];

  buildInputs =  [ gtk3 gdk-pixbuf libwnck ];

  configureFlags = [
    "--with-vendor-info='NixOS'"
  ];

  meta = with lib; {
    description = ''
      An abstraction library that attempts to present windowing concepts
      (screens, toplevel windows, workspaces, etc.) in a
      windowing-system-independent manner.
    '';
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
