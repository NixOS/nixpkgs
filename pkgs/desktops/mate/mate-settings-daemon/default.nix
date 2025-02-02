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
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-settings-daemon";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "TtfNraqkyZ7//AKCuEEXA7t24HLEHEtXmJ+MW0BhGjo=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook3
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
  ] ++ lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = lib.optional pulseaudioSupport "--enable-pulse";

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE settings daemon";
    homepage = "https://github.com/mate-desktop/mate-settings-daemon";
    license = with licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
      mit
    ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
