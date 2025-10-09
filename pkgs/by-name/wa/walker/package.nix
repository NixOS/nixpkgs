{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  glib,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  gdk-pixbuf,
  graphene,
  cairo,
  pango,
  poppler,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "walker";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-cSRd4ncUWjB59nRqY0X0eXioOIL7q7PwgOQggE54lTI=";
  };

  cargoHash = "sha256-Nm7KxZBvQOk4gOJCtMyMVASepJDrVmogHqv6Tc1r33Q=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    protobuf
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
    gdk-pixbuf
    graphene
    cairo
    pango
    poppler
  ];

  meta = {
    description = "Wayland-native application runner";
    homepage = "https://github.com/abenz1267/walker";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "walker";
  };
}
