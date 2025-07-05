{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  vips,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  nix-update-script,
  libqalculate,
}:

buildGoModule rec {
  pname = "walker";
  version = "0.12.28";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-OHBhSYWZ11wEMIwHlh6tK1AM/0JWV5PcoMC783uOUVs=";
  };

  vendorHash = "sha256-SG1JTl/Al9bRyDkzN7xliuZIAMifQJZdIeC5fr0WpWw=";
  subPackages = [ "cmd/walker.go" ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    vips
    gtk4-layer-shell
    libqalculate
  ];

  meta = with lib; {
    description = "Wayland-native application runner";
    homepage = "https://github.com/abenz1267/walker";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "walker";
  };
}
