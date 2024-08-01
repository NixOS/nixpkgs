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
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-crbBLK/xcdOkWtoLoV1gEK8UB3oyqnDk3zwbX+RR1Yk=";
  };

  vendorHash = "sha256-2t6WXQ5XoDtnlhzc96KeJ2cx+8sVS1oy2z3tsIRGq1Y=";

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
