{
  lib,
  stdenv,
  fetchFromGitLab,
  mesa,
  wayland,
  libglvnd,
  libbsd,
  libunwind,
  libelf,
  meson,
  ninja,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bionic-translation";
  version = "0-unstable-2025-01-19";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "38cbae66d5c82a26e6b81c4c17733f17fada4f85";
    hash = "sha256-CHBf77YAXiOoNwZxCCSCkHOBKwQXrWrWmZyHmhsYAVI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    mesa
    wayland.dev
    libglvnd
    libbsd
    libunwind
    libelf
  ];

  enableParallelBuilding = true;

  configurePhase = ''
    meson setup builddir
  '';

  buildPhase = ''
    cd builddir; meson compile
  '';

  installPhase = ''
    DESTDIR=$out meson install
  '';

  postInstall = ''
    mv $out/usr/local/lib $out/lib
    mv $out/usr/local/share $out/share
    rm -r $out/usr
  '';

  meta = {
    description = "Set of libraries for loading bionic-linked .so files on musl/glibc";
    homepage = "https://gitlab.com/android_translation_layer/bionic_translation";
    # No license specified yet
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
