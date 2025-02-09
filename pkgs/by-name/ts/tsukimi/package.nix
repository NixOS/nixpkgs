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
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "tsukinaha";
    repo = "tsukimi";
    tag = "v${version}";
    hash = "sha256-5hOOIkH0VhZwlsNKAyOI714ueGcSMagoLGi5ECfqXk4=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rgTrPJydS4685BlSEwNvmEajZEksqQicscOq/Uu9JJ4=";

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

    substituteInPlace src/lib.rs \
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
  };
}
