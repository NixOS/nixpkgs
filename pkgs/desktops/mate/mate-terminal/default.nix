{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  mate-desktop,
  dconf,
  vte,
  pcre2,
  wrapGAppsHook3,
<<<<<<< HEAD
  gitUpdater,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
  nixosTests,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-terminal";
  version = "1.28.1";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-terminal-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "8TXrGp4q4ieY7LLcGRT9tM/XdOa7ZcAVK+N8xslGnpI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    libxml2 # xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    mate-desktop
    pcre2
    vte
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-terminal";
    odd-unstable = true;
    rev-prefix = "v";
  };

  passthru.tests.test = nixosTests.terminal-emulators.mate-terminal;

  meta = {
    description = "MATE desktop terminal emulator";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  passthru.tests.test = nixosTests.terminal-emulators.mate-terminal;

  meta = with lib; {
    description = "MATE desktop terminal emulator";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
