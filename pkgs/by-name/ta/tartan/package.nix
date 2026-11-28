{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  llvmPackages_20,
  gobject-introspection,
  glib,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "tartan";
  version = "0.3.0-unstable-2025-11-09";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "59cda5f8cabd478154c1ee1742e28e9b0177b8f1";
    hash = "sha256-hbKoNcecziRbhE35sGrNpJC+TCZY/bQ+TqRFGUERTBo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gobject-introspection
    glib
    # https://gitlab.freedesktop.org/tartan/tartan/-/merge_requests/29
    llvmPackages_20.libclang
    llvmPackages_20.libllvm
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      # The updater tries src.url by default, which does not exist for fetchFromGitLab (fetchurl).
      url = "https://gitlab.freedesktop.org/tartan/tartan.git";
    };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tools and Clang plugins for developing code with GLib";
    homepage = "https://gitlab.freedesktop.org/tartan/tartan";
    changelog = "https://gitlab.freedesktop.org/tartan/tartan/-/blob/main/NEWS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
