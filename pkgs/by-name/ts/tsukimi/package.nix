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
  makeDesktopItem,
  copyDesktopItems,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "tsukimi";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "tsukinaha";
    repo = "tsukimi";
    rev = "v${version}";
    hash = "sha256-pJ+SUNGQS/kqBdOg21GgDeZThcjnB0FhgG00qLfqxYA=";
  };

  cargoHash = "sha256-PCJiSyfEgK8inzoRmRvnAU50kLnyVhNrgLrwtBUFpIU=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    copyDesktopItems
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

  desktopItems = [
    (makeDesktopItem {
      name = "Tsukimi";
      exec = "tsukimi";
      type = "Application";
      icon = "tsukimi";
      categories = [ "AudioVideo" ];
      startupWMClass = "moe.tsuna.tsukimi";
      desktopName = "Tsukimi";
    })
  ];

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail 'i18n/locale' "$out/share/locale"

    substituteInPlace src/main.rs \
      --replace-fail '/usr/share/locale' "$out/share/locale"
  '';

  postInstall = ''
    install -Dm644 moe.tsuna.tsukimi.gschema.xml -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas

    install -Dm644 resources/ui/icons/tsukimi.png -t $out/share/pixmaps
  '';

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
