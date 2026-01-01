{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  libcanberra-gtk3,
  libgtop,
  libXdamage,
  libXpresent,
  libXres,
  libstartup_notification,
  zenity,
  glib,
  gtk3,
  mate-desktop,
  mate-settings-daemon,
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
  pname = "marco";
  version = "1.28.1";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/marco-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "JJbl5A7pgM1oSUk6w+D4/Q3si4HGdNqNm6GaV38KwuE=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2 # xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    libcanberra-gtk3
    libgtop
    libXdamage
    libXpresent
    libXres
    libstartup_notification
    gtk3
    zenity
    mate-desktop
    mate-settings-daemon
  ];

  postPatch = ''
    substituteInPlace src/core/util.c \
      --replace-fail 'argvl[i++] = "zenity"' 'argvl[i++] = "${lib.getExe zenity}"'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
  env.ZENITY = lib.getExe zenity;

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/marco";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = [ lib.licenses.gpl2Plus ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
