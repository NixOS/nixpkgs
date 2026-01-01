{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3-x11,
  gobject-introspection,
  libxklavier,
  gitUpdater,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "libmatekbd";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "libmatekbd";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-6s8JiuXbBWOHxbNSuO8rglzOCRKlQ9fx/GsYYc08GmI=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3-x11
    libxklavier
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    odd-unstable = true;
  };

<<<<<<< HEAD
  meta = {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  meta = with lib; {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
