{
  lib,
  stdenv,
  fetchgit,
  testers,
  wrapGAppsHook3,
  gobject-introspection,
  texinfo,
  pkg-config,
  autoreconfHook,
  pulseaudio,
  libpng,
  gtk3,
  gdk-pixbuf,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xroar";
  version = "1.13.0.dev-unstable-2026-08-07";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://www.6809.org.uk/git/xroar.git";
    rev = "190788e71ae63a4ca44f4e6e66f907852aaf26bb";
    hash = "sha256-GMOh7EQT7u4JeRnIHaSIZqgTTWK4s/3jXtNscGuOm5w=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection

    texinfo
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    pulseaudio
    libpng
    gtk3
    gdk-pixbuf
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "xroar --version";
    version = "XRoar ${builtins.elemAt (lib.splitString "-" finalAttrs.version) 0}";
  };

  meta = {
    description = "Emulator for the Dragon 32/64; Tandy Colour Computers 1, 2 and 3; the Tandy MC-10; and others";
    homepage = "https://www.6809.org.uk/xroar/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      ceridwen15
    ];
    platforms = lib.platforms.linux;
    mainProgram = "xroar";
  };
})
