{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gettext,
  itstool,
  gtk3,
  libxml2,
  libxslt,
  libatasmart,
  libnotify,
  lm_sensors,
  mate-panel,
  hicolor-icon-theme,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-sensors-applet";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-sensors-applet-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "1GU2ZoKvj+uGGCg8l4notw22/RfKj6lQrG9xAQIxWoE=";
  };

  patches = [
    # Fix an invalid pointer crash with glib 2.83.2
    # https://github.com/mate-desktop/mate-sensors-applet/pull/137
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-sensors-applet/commit/9b74dc16d852a40d37f7ce6c236406959fd013e5.patch";
      hash = "sha256-PjMc2uEFMljaiKOM5lf6MsdWztZkMfb2Vuxs9tgdaos=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
  ];

  buildInputs = [
    gtk3
    libxml2
    libxslt
    libatasmart
    libnotify
    lm_sensors
    mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--enable-in-process" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-sensors-applet";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/mate-desktop/mate-sensors-applet";
    description = "MATE panel applet for hardware sensors";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    homepage = "https://github.com/mate-desktop/mate-sensors-applet";
    description = "MATE panel applet for hardware sensors";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
