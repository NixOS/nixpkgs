{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  libtool,
  gtk-layer-shell,
  gtk3,
  libcanberra-gtk3,
  libmatemixer,
  libxml2,
  mate-desktop,
  mate-panel,
  wayland,
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
  pname = "mate-media";
  version = "1.28.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-media-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "vNwQLiL2P1XmMWbVxwjpHBE1cOajCodDRaiGCeg6mRI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libcanberra-gtk3
    libmatemixer
    libxml2
    mate-desktop
    mate-panel
    wayland
  ];

  configureFlags = [ "--enable-in-process" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-media";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ chpatrick ];
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chpatrick ];
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
