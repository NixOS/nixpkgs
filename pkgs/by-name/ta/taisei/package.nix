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
  makeWrapper,
  # Runtime depends
  glfw,
  sdl3,
  SDL2_mixer,
  cglm,
  freetype,
  libpng,
  libwebp,
  zlib,
  zstd,
  spirv-cross,
  mimalloc,

  gamemodeSupport ? stdenv.hostPlatform.isLinux,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taisei";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "taisei-project";
    repo = "taisei";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cs66kyNSVjUZUH+ddZGjFwSUQtwqX4uuGQh+ZLv6N6o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    docutils
    meson
    ninja
    pkg-config
    python3Packages.python
    python3Packages.zstandard
    shaderc
    makeWrapper
  ];

  buildInputs = [
    glfw
    sdl3
    SDL2_mixer
    cglm
    freetype
    libpng
    libwebp
    zlib
    zstd
    opusfile
    openssl
    spirv-cross
    mimalloc
  ]
  ++ lib.optional gamemodeSupport gamemode;

  mesonFlags = [
    (lib.mesonBool "b_lto" false)
    (lib.mesonEnable "install_macos_bundle" false)
    (lib.mesonEnable "install_relocatable" false)
    (lib.mesonEnable "shader_transpiler" false)
    (lib.mesonEnable "shader_transpiler_dxbc" false)
    (lib.mesonEnable "gamemode" gamemodeSupport)
    (lib.mesonEnable "package_data" false)
    (lib.mesonEnable "vfs_zip" false)
  ];

  preConfigure = ''
    patchShebangs .
  '';

  postInstall = lib.optionalString gamemodeSupport ''
    wrapProgram $out/bin/taisei \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ gamemode ]}
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
