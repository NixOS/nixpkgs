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
}:

buildGo127Module (finalAttrs: {
  pname = "trayscale";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "DeedleFake";
    repo = "trayscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I/HBbw/sRU8nL0Yp2ZA0QVo/0rvLwhdPeTigWfsusZE=";
  };

  vendorHash = "sha256-sSYyEWSHKhmERmXJFUIRnTxvtwthyUnTl/SUqW0q52w=";

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
    sh ./dist.sh install $out
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${tailscale}/bin")
  '';

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
