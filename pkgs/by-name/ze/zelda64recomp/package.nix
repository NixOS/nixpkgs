{
  lib,
  SDL2,
  cmake,
  copyDesktopItems,
  directx-shader-compiler,
  fetchFromGitHub,
  fetchurl,
  gtk3,
  llvmPackages_18,
  makeDesktopItem,
  makeWrapper,
  n64recomp,
  ninja,
  pkg-config,
  requireFile,
  vulkan-loader,
  wrapGAppsHook3,
  z64decompress,
}:

let

  baseRom = requireFile {
    name = "mm.us.rev1.rom.z64";
    message = ''
      zelda64recomp currently only supports the US version of Majora's Mask.

      Please rename your copy to mm.us.rev1.rom.z64 and add it to the nix store using

      nix-store --add-fixed sha256 mm.us.rev1.rom.z64

      and rebuild.
    '';
    hash = "sha256-77E2WzrjYmBFFMD5oaLRH13IaIulvmYKN96/XjvkPys=";
  };

  gamecontrollerdb = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "cfc2bffe0ad29fea2bec7a0f4cb19dead5703ea8";
    hash = "sha256-BEN0/q+7iLVmPpOO3i80nuLYpr7KiHd2ONxKmDIJuWU=";
  };

in

llvmPackages_18.stdenv.mkDerivation (finalAttrs: {
  pname = "zelda64recomp";
  version = "1.1.1-unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "Zelda64Recomp";
    repo = "Zelda64Recomp";
    rev = "0d0f64e32f15c2ecc95c9e4945caa37ec19ce1ce";
    hash = "sha256-JtNXTP6XrIzjccfRzffZ5uRhuLbfAlkfGmGO18yEZPc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    llvmPackages_18.lld
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
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/bin/x64/dxc" "${directx-shader-compiler}/bin/dxc" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/inc" "${directx-shader-compiler.src}/include/dxc"

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/bin/x64/dxc" "${directx-shader-compiler}/bin/dxc"
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

    install -Dm755 -t $out/bin Zelda64Recompiled
    install -Dm644 -t $out/share ../gamecontrollerdb.txt
    install -Dm644 ../icons/512.png $out/share/icons/hicolor/scalable/apps/zelda64recomp.png
    ln -s $out/share/gamecontrollerdb.txt $out/bin/gamecontrollerdb.txt
    cp -r ../assets $out/bin/

    install -Dm644 -t $out/share/licenses/${finalAttrs.pname} ../COPYING
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/N64ModernRuntime ../lib/N64ModernRuntime/COPYING
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/RmlUi ../lib/RmlUi/LICENSE.txt
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/SDL_GameControllerDB ${gamecontrollerdb}/LICENSE
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/lunasvg ../lib/lunasvg/LICENSE
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/rt64 ../lib/rt64/LICENSE
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname}/sse2neon ../lib/sse2neon/LICENSE

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
