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
  version = "0.3.0-unstable-2025-01-07";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "983aaf238946ced55da8824c1170a254992d9717";
    hash = "sha256-4w9cAs6kA+RAmi2CC+5CHB1UWC+7zkBqvZlHAdgENu4=";
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
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tools and Clang plugins for developing code with GLib";
    homepage = "https://gitlab.freedesktop.org/tartan/tartan";
    changelog = "https://gitlab.freedesktop.org/tartan/tartan/-/blob/main/NEWS";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
