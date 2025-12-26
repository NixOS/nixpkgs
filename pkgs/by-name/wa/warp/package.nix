{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  cargo,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  libcamera,
  pipewire,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "warp";
    tag = "v${version}";
    hash = "sha256-60FhXIO1etcMhZJuSQjO2UWrkwV+AJOFmaAIi3uLpzY=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-sQFJ+eR/Ywl3KPN50P2RVHKAjxtOUb6YRoThRb5aMe8=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libcamera
    pipewire
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good # multifilesink
    gst-plugins-rs # gst-plugin-gtk4
  ]);

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : ${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/Warp/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      foo-dogsquared
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.all;
    mainProgram = "warp";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
