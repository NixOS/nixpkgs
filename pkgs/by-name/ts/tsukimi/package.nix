{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  mpv-unwrapped,
  ffmpeg,
  libadwaita,
  gst_all_1,
  openssl,
  libepoxy,
  wrapGAppsHook4,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tsukimi";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "tsukinaha";
    repo = "tsukimi";
    rev = "v${version}";
    hash = "sha256-2AmDP4R06toNrtjV0HSO+Fj8mrXbLgC7bMQPvl10un0=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3xu4h9ZHlqnaB6Pgn2ixyBF3VS6OF8ZkLaNU4unir7A=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      mpv-unwrapped
      ffmpeg
      libadwaita
      openssl
      libepoxy
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);

  doCheck = false; # tests require networking

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail 'i18n/locale' "$out/share/locale"

    substituteInPlace src/main.rs \
      --replace-fail '/usr/share/locale' "$out/share/locale"
  '';

  postInstall = ''
    install -Dm644 resources/moe.tsuna.tsukimi.gschema.xml -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas

    install -Dm644 resources/icons/tsukimi.png -t $out/share/pixmaps

    install -Dm644 resources/moe.tsuna.tsukimi.desktop.in $out/share/applications/moe.tsuna.tsukimi.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple third-party Emby client, featured with GTK4-RS, MPV and GStreamer";
    homepage = "https://github.com/tsukinaha/tsukimi";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      merrkry
      aleksana
    ];
    mainProgram = "tsukimi";
    platforms = lib.platforms.linux;
    # libmpv2 crate fail to compile
    # expected raw pointer `*const u8` found raw pointer `*const i8`
    broken = stdenv.hostPlatform.isAarch64;
  };
}
