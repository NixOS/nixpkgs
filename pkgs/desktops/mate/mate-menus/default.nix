{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pkg-config,
  gettext,
  glib,
  gobject-introspection,
<<<<<<< HEAD
  mate-common,
  python3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-menus";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-menus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAc9DPsXdswmyNKlbY6cyHBWO2OSKCBygtzttNHN/p4=";
  };
  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    gobject-introspection
    mate-common # mate-common.m4 macros
=======
  python3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-menus";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "z0DHXH1vCq0dSWmCj8YgJcYiK8aoTwu51urX5FlwUI0=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    glib
    python3
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-menus";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Menu system for MATE";
    homepage = "https://github.com/mate-desktop/mate-menus";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Menu system for MATE";
    homepage = "https://github.com/mate-desktop/mate-menus";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
