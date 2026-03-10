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
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8ybD6u78Em3Vbm+yFNa4mCxSDjr047Twcwo4jEz+3Uo=";
  };

  cargoHash = "sha256-UrZw/FXBWIl2fQbGrTnT0ae7XEKdvuJXZuUeYFFgzrs=";

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
    changelog = "https://github.com/abenz1267/walker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      adamcstephens
      donovanglover
      saadndm
    ];
    mainProgram = "walker";
  };
})
