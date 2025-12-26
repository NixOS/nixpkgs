{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  libxklavier,
  libcanberra-gtk3,
  libnotify,
  libmatekbd,
  libmatemixer,
  nss,
  polkit,
  dconf,
  gtk3,
  mate-desktop,
  pulseaudioSupport ? stdenv.config.pulseaudio or true,
  libpulseaudio,
  wrapGAppsHook3,
  gitUpdater,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-settings-daemon";
  version = "1.28.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-settings-daemon-${finalAttrs.version}.tar.xz";
    sha256 = "TtfNraqkyZ7//AKCuEEXA7t24HLEHEtXmJ+MW0BhGjo=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook3
    udevCheckHook
  ];

  buildInputs = [
    libxklavier
    libcanberra-gtk3
    libnotify
    libmatekbd
    libmatemixer
    nss
    polkit
    gtk3
    dconf
    mate-desktop
  ]
  ++ lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = lib.optional pulseaudioSupport "--enable-pulse";

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-settings-daemon";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE settings daemon";
    homepage = "https://github.com/mate-desktop/mate-settings-daemon";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
      mit
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
