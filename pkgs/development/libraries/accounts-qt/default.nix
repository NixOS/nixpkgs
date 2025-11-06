{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  doxygen,
  glib,
  libaccounts-glib,
  pkg-config,
  qmake,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "accounts-qt";
  version = "1.17";

  # pinned to fork with Qt6 support
  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-qt";
    rev = "refs/tags/VERSION_${finalAttrs.version}";
    hash = "sha256-mPZgD4r7vlUP6wklvZVknGqTXZBckSOtNzK7p6e2qSA=";
  };

  propagatedBuildInputs = [
    glib
    libaccounts-glib
  ];
  buildInputs = [ qtbase ];
  nativeBuildInputs = [
    doxygen
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  # remove forbidden references to /build
  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out"/bin/*
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "VERSION_";
  };

  meta = with lib; {
    description = "Qt library for accessing the online accounts database";
    mainProgram = "accountstest";
    homepage = "https://gitlab.com/accounts-sso/libaccounts-qt";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
})
