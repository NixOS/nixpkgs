{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  llvmPackages,
  gobject-introspection,
  glib,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "tartan";
  version = "0.3.0-unstable-2023-10-11";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "4a7c945535d746d3d874ebebc0217715d674a862";
    hash = "sha256-DYvbBGgytf1JOYKejZB+ReehD8iKm1n4BhMmLQURay0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gobject-introspection
    glib
    llvmPackages.libclang
    llvmPackages.libllvm
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      # The updater tries src.url by default, which does not exist for fetchFromGitLab (fetchurl).
      url = "https://gitlab.freedesktop.org/tartan/tartan.git";
    };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Tools and Clang plugins for developing code with GLib";
    homepage = "https://gitlab.freedesktop.org/tartan/tartan";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
