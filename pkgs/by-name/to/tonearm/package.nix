{
  buildGoModule,
  cairo,
  copyDesktopItems,
  fetchFromGitea,
  gdk-pixbuf,
  glib,
  glib-networking,
  gobject-introspection,
  graphene,
  gst_all_1,
  gtk4,
  lib,
  libadwaita,
  libsecret,
  librsvg,
  makeDesktopItem,
  makeWrapper,
  pango,
  pkg-config,
  symlinkJoin,
  wrapGAppsHook4,
}:
let
  libraryPath = symlinkJoin {
    name = "tonearm-puregotk-lib-folder";
    paths = [
      cairo
      gdk-pixbuf
      glib.out
      graphene
      pango.out
      gtk4
      libadwaita
      libsecret
      gobject-introspection
      librsvg
    ];
  };
in
buildGoModule (finalAttrs: {
  pname = "tonearm";
  version = "1.2.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dergs";
    repo = "Tonearm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2on27z3BRf63gjs3NKmF9H0Le7hBdaHRUp8WQgFs3QU=";
  };
  vendorHash = "sha256-j+7cobxVGNuZFYeRn5ad7XT4um8WNWE1byFo7qo9zK0=";

  ldflags = [
    "-X \"codeberg.org/dergs/tonearm/internal/ui.Version=${finalAttrs.version}\""
  ];

  buildInputs = [
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gtk4
    libsecret
  ];
  doCheck = false;
  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    makeWrapper
    wrapGAppsHook4
  ];

  subPackages = [
    "cmd/tonearm"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dev.dergs.Tonearm";
      exec = "tonearm %u";
      icon = "dev.dergs.Tonearm";
      comment = "Tonearm is a GTK client for TIDAL written in GoLang.";
      desktopName = "Tonearm";
      mimeTypes = [
        "x-scheme-handler/tidal"
      ];
      categories = [
        "Audio"
        "AudioVideo"
        "Music"
        "GNOME"
        "GTK"
      ];
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/tonearm \
      --prefix GST_PLUGIN_PATH : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --set-default PUREGOTK_LIB_FOLDER ${libraryPath}/lib \
      ''${gappsWrapperArgs[@]}
    install -Dm444 internal/icons/hicolor/scalable/apps/dev.dergs.Tonearm.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm444 internal/icons/hicolor/128x128/apps/dev.dergs.Tonearm.png -t $out/share/icons/hicolor/128x128/apps
    install -Dm444 internal/icons/hicolor/symbolic/apps/dev.dergs.Tonearm-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps
    install -Dm444 internal/settings/dev.dergs.Tonearm.gschema.xml -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    description = "GTK client for TIDAL written in Golang";
    homepage = "https://codeberg.org/dergs/Tonearm";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      drafolin
      nilathedragon
    ];
    mainProgram = "tonearm";
  };
})
