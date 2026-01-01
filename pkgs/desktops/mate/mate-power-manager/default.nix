{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  itstool,
  libxml2,
  mate-desktop,
  mate-panel,
  libnotify,
  libcanberra-gtk3,
  libsecret,
  dbus-glib,
  upower,
  gtk3,
  libtool,
  polkit,
  wrapGAppsHook3,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-power-manager";
  version = "1.28.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-power-manager-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "jr3LdLYH6Ggza6moFGze+Pl7zlNcKwyzv2UMWPce7iE=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    itstool
    libxml2
    libcanberra-gtk3
    gtk3
    libsecret
    libnotify
    dbus-glib
    upower
    polkit
    mate-desktop
    mate-panel
  ];

  configureFlags = [ "--enable-applets" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-power-manager";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ chpatrick ];
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      fdl11Plus
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ chpatrick ];
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
