{
  lib,
  stdenv,
  fetchFromGitHub,
  # Build depends
  docutils,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  opusfile,
  openssl,
  gamemode,
  shaderc,
  ensureNewerSourcesForZipFilesHook,
  # Runtime depends
  glfw,
  SDL2,
  SDL2_mixer,
  cglm,
  freetype,
  libpng,
  libwebp,
  libzip,
  zlib,
  zstd,
  spirv-cross,

  gamemodeSupport ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taisei";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "taisei-project";
    repo = "taisei";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rThLz8o6IYhIBUc0b1sAQi2aF28btajcM1ScTv+qn6c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    docutils
    meson
    ninja
    pkg-config
    python3Packages.python
    python3Packages.zstandard
    ensureNewerSourcesForZipFilesHook
    shaderc
  ];

  buildInputs = [
    glfw
    SDL2
    SDL2_mixer
    cglm
    freetype
    libpng
    libwebp
    libzip
    zlib
    zstd
    opusfile
    openssl
    spirv-cross
  ] ++ lib.optional gamemodeSupport gamemode;

  mesonFlags = [
    (lib.mesonBool "b_lto" false)
    (lib.mesonEnable "install_macos_bundle" false)
    (lib.mesonEnable "install_relocatable" false)
    (lib.mesonEnable "shader_transpiler" false)
    (lib.mesonEnable "gamemode" gamemodeSupport)
  ];

  preConfigure = ''
    patchShebangs .
  '';

  strictDeps = true;

  meta = {
    description = "Free and open-source Touhou Project clone and fangame";
    mainProgram = "taisei";
    longDescription = ''
      Taisei is an open clone of the Tōhō Project series. Tōhō is a one-man
      project of shoot-em-up games set in an isolated world full of Japanese
      folklore.
    '';
    homepage = "https://taisei-project.org/";
    license = with lib.licenses; [
      mit
      cc-by-40
    ];
    maintainers = with lib.maintainers; [
      lambda-11235
      Gliczy
    ];
    platforms = lib.platforms.all;
  };
})
