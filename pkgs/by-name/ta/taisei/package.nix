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
  cmake,
  mimalloc,
  glslang,
  libogg,
  makeBinaryWrapper,

  # Runtime depends
  sdl3,
  cglm,
  freetype,
  libpng,
  libwebp,
  zlib,
  zstd,
  spirv-cross,

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
    makeBinaryWrapper
    cmake
  ];

  buildInputs = [
    sdl3
    cglm
    freetype
    libpng
    libwebp
    zlib
    zstd
    opusfile
    openssl
    mimalloc
    libogg
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    glslang
    spirv-cross
  ]
  ++ lib.optional gamemodeSupport gamemode;

  # Forced to use builtin-sincos because the symbol isn't available otherwise
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin " -Dsincos=__builtin_sincos";

  mesonFlags = [
    (lib.mesonEnable "vfs_zip" false)
    (lib.mesonEnable "shader_transpiler_dxbc" false)
    (lib.mesonEnable "package_data" false)
    (lib.mesonBool "b_lto" false)
    (lib.mesonEnable "gamemode" gamemodeSupport)
    (lib.mesonEnable "install_freedesktop" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "install_macos_bundle" stdenv.hostPlatform.isDarwin)
    (lib.mesonEnable "install_relocatable" stdenv.hostPlatform.isDarwin)
    (lib.mesonEnable "shader_transpiler" stdenv.hostPlatform.isDarwin)
  ];

  preConfigure = ''
    patchShebangs .
  '';

  postInstall =
    lib.optionalString (stdenv.hostPlatform.isLinux && gamemodeSupport) ''
      wrapProgram $out/bin/taisei \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gamemode ]}"
    ''
    +

      lib.optionalString stdenv.hostPlatform.isDarwin ''
        mkdir -p $out/Applications $out/bin

        mv $out/Taisei.app $out/Applications/
        # regular symlink will fail here due to resources being missed
        makeBinaryWrapper $out/Applications/Taisei.app/Contents/MacOS/Taisei $out/bin/taisei
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
      philocalyst
    ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/taisei-project/taisei/releases/tag/${finalAttrs.src.tag}";
  };
})
