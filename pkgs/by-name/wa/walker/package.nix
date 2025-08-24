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
  version = "0.13.26";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-LslpfHXj31Lvq+26ZDzCTaGBbxmp7yXlgKT+uwUEEts=";
  };

  vendorHash = "sha256-N7lNxO/l3E1BlSSbSiQjrDPy2sWwk4G4JYlUArmMJxs=";
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
