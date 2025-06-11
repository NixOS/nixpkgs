{
  lib,
  stdenv,
  fetchzip,
  desktop-file-utils,
  intltool,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gssdp_1_6,
  gtk3,
  gupnp_1_6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upnp-router-control";
  version = "0.3.5";

  src = fetchzip {
    url = "https://launchpad.net/upnp-router-control/trunk/${finalAttrs.version}/+download/upnp-router-control-${finalAttrs.version}.tar.xz";
    hash = "sha256-+yJzULNdzBkUw2EbHXoAbR9B/P0d6n8T7ojlYIrKgto=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gssdp_1_6
    gtk3
    gupnp_1_6
  ];

  meta = {
    # also https://gitlab.gnome.org/DnaX/upnp-router-control
    homepage = "https://launchpad.net/upnp-router-control";
    description = "Access some parameters of the router and manage port forwarding";
    longDescription = ''
      A GTK application to access some parameters of the router like:
      the network speed, the external IP and the model name.
      It can manage port forwarding through a simple GUI interface.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "upnp-router-control";
  };
})
