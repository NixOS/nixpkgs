{
  lib,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  glib,
  gobject-introspection,
  gst_all_1,
  gtk4,
  gtk4-layer-shell,
  gdk-pixbuf,
  graphene,
  cairo,
  pango,
  wrapGAppsHook4,
  poppler,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "walker";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y1jBFFO0u+V21y3YldHZozrDwVJVrdC+o3c4M8/rasU=";
  };

  cargoHash = "sha256-7QQdHbkwjVcZCd2FaBxLL5BUSoWjTsH1GuDhzh7DuRY=";

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    protobuf
    wrapGAppsHook4
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
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-libav
  ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland-native application runner";
    homepage = "https://github.com/abenz1267/walker";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      donovanglover
      saadndm
    ];
    mainProgram = "walker";
  };
})
