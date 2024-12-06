{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  nix-update-script,
}:

buildGoModule rec {
  pname = "walker";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-nYC6KoLsmMf6uJ74Y2zvDU5wdgeOU9aZb/4zGlnWOJM=";
  };

  vendorHash = "sha256-nc/WKBhUxhs1aNUg/GM7vhrKd7FrUdl2uKp7MX2VCdE=";
  subPackages = [ "cmd/walker.go" ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
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
