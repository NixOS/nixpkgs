{
  lib,
  mm64baserom ? null,
  requireFile,
  fetchFromGitHub,
  llvmPackages_19,
  cmake,
  copyDesktopItems,
  installShellFiles,
  makeWrapper,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  SDL2,
  gtk3,
  vulkan-loader,
  makeDesktopItem,
  z64decompress,
  n64recomp,
  directx-shader-compiler,
}:

let

  baseRom =
    if mm64baserom != null then
      mm64baserom
    else
      requireFile {
        name = "mm.us.rev1.rom.z64";
        message = ''
          zelda64recomp currently only supports the US version of Majora's Mask.
          Please dump your copy and rename it to mm.us.rev1.rom.z64
          and add it to the nix store using
          nix-store --add-fixed sha256 mm.us.rev1.rom.z64
          See https://dumping.guide/carts/nintendo/n64 for more details.
        '';
        hash = "sha256-77E2WzrjYmBFFMD5oaLRH13IaIulvmYKN96/XjvkPys=";
      };

  gamecontrollerdb = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "dc9ea05a2a6b9b9132037098e24fb704a7089b4b";
    hash = "sha256-oyoungREfnla+TFFEmOSJaN8/z5SvF29H9ewZ8a8B0o=";
  };

in

llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
  pname = "zelda64recomp";
  version = "1.1.1-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "Zelda64Recomp";
    repo = "Zelda64Recomp";
    rev = "c6d77fe5cac0b6843663a8d75e9af49433f547ae";
    hash = "sha256-EkLLQd6UVPjI29xCAfcU/ACeP9jak8IQhKBpRQDCkcQ=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    installShellFiles
    llvmPackages_19.lld
    makeWrapper
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    gtk3
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
    ln -s ${baseRom} ./mm.us.rev1.rom.z64
    ${lib.getExe z64decompress} mm.us.rev1.rom.z64 mm.us.rev1.rom_uncompressed.z64
    cp ${n64recomp}/bin/* .
    cp ${gamecontrollerdb}/gamecontrollerdb.txt gamecontrollerdb.txt

    ./N64Recomp us.rev1.toml
    ./RSPRecomp aspMain.us.rev1.toml
    ./RSPRecomp njpgdspMain.us.rev1.toml

    substituteInPlace lib/rt64/CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/bin/x64/dxc-linux" "${directx-shader-compiler}/bin/dxc" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/inc" "${directx-shader-compiler.src}/include/dxc"

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/bin/x64/dxc-linux" "${directx-shader-compiler}/bin/dxc"
  '';

  # This is required or else nothing will build
  hardeningDisable = [
    "format"
    "pic"
    "stackprotector"
    "zerocallusedregs"
  ];

  patches = [
    # Disable cmake attempting to fetch gamecontrollerdb
    ./0001-disable-cmake-downloading-gamecontrollerdb.txt.patch
  ];

  installPhase = ''
    runHook preInstall

    installBin Zelda64Recompiled
    install -Dm644 -t $out/share ../gamecontrollerdb.txt
    install -Dm644 ../icons/512.png $out/share/icons/hicolor/scalable/apps/zelda64recomp.png
    cp -r ../assets $out/share/
    ln -s $out/share/gamecontrollerdb.txt $out/bin/gamecontrollerdb.txt
    ln -s $out/share/assets $out/bin/assets

    install -Dm644 -t $out/share/licenses/${finalAttrs.pname} ../COPYING
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/N64ModernRuntime ../lib/N64ModernRuntime/COPYING
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/RmlUi ../lib/RmlUi/LICENSE.txt
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/SDL_GameControllerDB ${gamecontrollerdb}/LICENSE
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/lunasvg ../lib/lunasvg/LICENSE
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/rt64 ../lib/rt64/LICENSE

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
      # Zelda64Recomp, N64ModernRuntime
      gpl3Only

      # RT64, RmlUi, lunasvg, sse2neon
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "Zelda64Recompiled";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
})
