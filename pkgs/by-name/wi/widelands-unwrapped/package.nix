{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config, # needed to find minizip
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  cmake,
  curl,
  doxygen,
  gettext,
  glew,
  graphviz,
  icu,
  installShellFiles,
  libpng,
  lua5_2_compat,
  python3,
  zlib,
  minizip,
  asio,
  libsm,
  libice,
  libxext,
  libx11,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "widelands-unwrapped";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "widelands";
    repo = "widelands";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nNciOfE9fqd1CfljrELy2/I7+o1BLcpdngE3XGPQaSk=";
  };

  cmakeFlags = [
    "-Wno-dev" # dev warnings are only needed for upstream development
    "-DWL_INSTALL_BASEDIR=${placeholder "out"}/share/widelands" # for COPYING, Changelog, etc.
    "-DWL_INSTALL_DATADIR=${placeholder "out"}/share/widelands" # for game data
    "-DWL_INSTALL_BINDIR=${placeholder "out"}/bin"
    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    installShellFiles
    pkg-config
    python3
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    curl
    glew
    icu
    libpng
    lua
    zlib
    minizip
    asio
    libsm # XXX: these should be propagated by SDL2?
    libice
    libx11
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libxext;

  # Skip data components (VersionFile, CoreDataFiles, MapFiles, MusicFiles).
  installPhase = ''
    runHook preInstall

    for comp in CoreVersionFile CoreLicenseFiles ExecutableFiles Unspecified; do
      cmake --install . --component "$comp"
    done

    runHook postInstall
  '';

  # xdg/CMakeLists.txt is only added on non-Apple Unix platforms.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    installManPage ../xdg/widelands.6
  '';

  meta = {
    description = "RTS with multiple-goods economy (unwrapped)";
    homepage = "https://widelands.org/";
    longDescription = ''
      Widelands is a real time strategy game based on "The Settlers" and "The
      Settlers II". It has a single player campaign mode, as well as a networked
      multiplayer mode.
    '';
    changelog = "https://github.com/widelands/widelands/releases/tag/v${finalAttrs.version}";
    mainProgram = "widelands";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      jcumming
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
