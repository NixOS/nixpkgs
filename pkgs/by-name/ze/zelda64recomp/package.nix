{
  lib,
  llvmPackages,
  llvm,
  clang,
  lld,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  gtk3,
  SDL2,
  ares,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  mm-decomp,
  n64recomp,
  libXdmcp,
  libxkbcommon,
  libepoxy,
  libXtst,
  directx-shader-compiler,
  makeWrapper,
  vulkan-loader,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "zelda64recomp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Zelda64Recomp";
    repo = "Zelda64Recomp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q4eigP1/Lxh/VokPAe67lOoZSyHktzkUh99ewRTcG68=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    ares
    lld
    llvm
    clang
    makeWrapper
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    SDL2
    ares
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    libepoxy
    libXtst
    vulkan-loader
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Zelda64Recompiled";
      icon = "zelda64recomp";
      exec = "Zelda64Recompiled";
      comment = "Static recompilation of Majora's Mask";
      genericName = "Static recompilation of Majora's Mask";
      desktopName = "Zelda 64: Recompiled";
      categories = [ "Game" ];
    })
  ];

  preConfigure = ''
    cp ${mm-decomp}/bin/* .
    cp ${n64recomp}/bin/* .

    ./N64Recomp us.rev1.toml
    ./RSPRecomp aspMain.us.rev1.toml
    ./RSPRecomp njpgdspMain.us.rev1.toml

    substituteInPlace lib/rt64/CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/bin/x64/dxc" "${directx-shader-compiler}/bin/dxc" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/inc" "${directx-shader-compiler.src}/include/dxc"

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/bin/x64/dxc" "${directx-shader-compiler}/bin/dxc"
  '';

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release") ];

  # This is required or else nothing will build
  hardeningDisable = [
    "stackprotector"
    "pic"
    "format"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin Zelda64Recompiled
    cp -r ../assets $out/bin/

    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm755 ../icons/512.png $out/share/icons/hicolor/scalable/apps/zelda64recomp.png

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
     )
  '';

  postFixup = ''
    # This is needed as Zelda64Recompiled will segfault when not run from the same directory as the binary
    # It will also exit if run with SDL_VIDEODRIVER=wayland
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/Zelda64Recompiled \
      --run "cd $out/bin/" \
      --set SDL_VIDEODRIVER x11
  '';

  meta = {
    description = "Static recompilation of Majora's Mask (and soon Ocarina of Time) for PC (Windows/Linux)";
    homepage = "https://github.com/Zelda64Recomp/Zelda64Recomp";
    license = with lib.licenses; [
      # Zelda64Recomp
      gpl3Only

      # RT64
      mit

      # Includes data from mm-decomp
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "Zelda64Recompiled";
    platforms = [ "x86_64-linux" ];
  };
})
