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
  version = "0-unstable-2024-11-06";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "60f1f64de330e734c2476c51ac6aec67396a4781";
    hash = "sha256-P2BRUJyubQTDrItdFdsog0sCFbApR4Y2UToLxrbQyiw=";
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

  configurePhase = ''
    meson setup builddir
  '';

  buildPhase = ''
    cd builddir; meson compile
  '';

  installPhase = ''
    DESTDIR=$out meson install; mv $out/usr/local/lib $out/lib; mv $out/usr/local/share $out/share; rm -r $out/usr
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
