{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  python3,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  gtk4,
  libadwaita,
  json-glib,
  gexiv2,
  glib,
  glib-networking,
  gnome,
  gobject-introspection,
  gtksourceview5,
  libxml2,
  libgee,
  librsvg,
  libsoup_3,
  libsecret,
  libwebp,
  libspelling,
  webkitgtk_6_0,
  webp-pixbuf-loader,
  icu,
  gst_all_1,
  clapper-enhancers,
  clapper-unwrapped,
  clapperSupport ? true,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "tuba";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
    hash = "sha256-uMfxHQOjL1bnKAz0MUUEv2IR4aRiR4UhIM5aHPspJDU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gexiv2
    glib
    glib-networking
    gtksourceview5
    json-glib
    libxml2
    libgee
    libsoup_3
    gtk4
    libadwaita
    libsecret
    libwebp
    libspelling
    webkitgtk_6_0
    icu
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ])
  ++ lib.optionals clapperSupport [
    clapper-unwrapped
  ];

  mesonFlags = [
    (lib.mesonEnable "clapper" clapperSupport)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=int-conversion";

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default CLAPPER_ENHANCERS_PATH "${clapper-enhancers}/${clapper-enhancers.passthru.pluginPath}"
    )
  '';

  # Pull in WebP support for avatars from Misskey instances.
  # In postInstall to run before gappsWrapperArgsHook.
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    mainProgram = "dev.geopjr.Tuba";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/GeopJr/Tuba/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      chuangzhu
      donovanglover
    ];
    teams = [ lib.teams.gnome-circle ];
  };
}
