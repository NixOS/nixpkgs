{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  tailscale,
  gtk4,
  gobject-introspection,
  libadwaita,
  desktopToDarwinBundle,
  symlinkJoin,
  cairo,
  gdk-pixbuf,
  glib,
  graphene,
  pango,
}:

buildGo127Module (finalAttrs: {
  pname = "trayscale";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "DeedleFake";
    repo = "trayscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Wv+jLkGVpPfvEMVBpliOAJNG6/XVX93q3l9qIChVpg=";
  };

  vendorHash = "sha256-bxiloB4cJHY45nMYczEToCExj3ZlvDKqA7yYAbgGmi4=";

  subPackages = [ "cmd/trayscale" ];

  ldflags = [
    "-s"
    "-w"
    "-X=deedles.dev/trayscale/internal/metadata.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];
  buildInputs = [
    gtk4
    libadwaita
  ];

  # there are no actual tests, and it takes 20 minutes to rebuild
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/trayscale \
      --set-default PUREGOTK_LIB_FOLDER ${finalAttrs.passthru.libraryPath}/lib

    sh ./dist.sh install-data $out
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${tailscale}/bin")
  '';

  passthru = {
    libraryPath = symlinkJoin {
      name = "trayscale-puregotk-lib";
      paths = [
        cairo
        gdk-pixbuf
        glib.out
        graphene
        gtk4
        libadwaita
        pango.out
      ];
    };
  };

  meta = {
    changelog = "https://github.com/DeedleFake/trayscale/releases/tag/${finalAttrs.src.rev}";
    description = "Unofficial GUI wrapper around the Tailscale CLI client";
    homepage = "https://github.com/DeedleFake/trayscale";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "trayscale";
    platforms = lib.platforms.unix;
  };
})
