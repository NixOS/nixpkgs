{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
}:

buildGoModule rec {
  pname = "walker";
  version = "0.0.71";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-ShLwQBWhaoeHijiQCMO3n0DnhNaEd8GOrYMcli5EIZs=";
  };

  vendorHash = "sha256-zDntJ695k8dbwyFXbg9PapWD335MHrWbep1xxzXNIL4=";

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
