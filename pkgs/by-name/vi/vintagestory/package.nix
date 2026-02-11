{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  gtk2,
  sqlite,
  openal,
  cairo,
  libGLU,
  SDL2,
  freealut,
  libglvnd,
  pipewire,
  libpulseaudio,
  dotnet-runtime_8,
  x11Support ? true,
  libxi,
  libxcursor,
  libx11,
  waylandSupport ? false,
  wayland ? null,
  libxkbcommon ? null,
}:

assert x11Support || waylandSupport;
assert waylandSupport -> wayland != null;
assert waylandSupport -> libxkbcommon != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "vintagestory";
  version = "1.21.6";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${finalAttrs.version}.tar.gz";
    hash = "sha256-LkiL/8W9MKpmJxtK+s5JvqhOza0BLap1SsaDvbLYR0c=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  runtimeLibs = [
    gtk2
    sqlite
    openal
    cairo
    libGLU
    SDL2
    freealut
    libglvnd
    pipewire
    libpulseaudio
  ]
  ++ lib.optionals x11Support [
    libx11
    libxi
    libxcursor
  ]
  ++ lib.optionals waylandSupport [
    wayland
    libxkbcommon
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "vintagestory";
      desktopName = "Vintage Story";
      exec = "vintagestory";
      icon = "vintagestory";
      comment = "Innovate and explore in a sandbox world";
      categories = [ "Game" ];
    })

    (makeDesktopItem {
      name = "vsmodinstall-handler";
      desktopName = "Vintage Story 1-click Mod Install Handler";
      comment = "Handler for vintagestorymodinstall:// URI scheme";
      exec = "vintagestory -i %u";
      mimeTypes = [ "x-scheme-handler/vintagestorymodinstall" ];
      noDisplay = true;
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vintagestory $out/bin $out/share/pixmaps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory
    cp $out/share/vintagestory/assets/gameicon.xpm $out/share/pixmaps/vintagestory.xpm
    cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  preFixup =
    let
      runtimeLibs' = lib.strings.makeLibraryPath finalAttrs.runtimeLibs;
    in
    ''
      makeWrapper ${lib.meta.getExe dotnet-runtime_8} $out/bin/vintagestory \
        --prefix LD_LIBRARY_PATH : "${runtimeLibs'}" \
        --set-default mesa_glthread true \
        ${lib.strings.optionalString waylandSupport ''
          --set-default OPENTK_4_USE_WAYLAND 1 \
        ''} \
        --add-flags $out/share/vintagestory/Vintagestory.dll

      makeWrapper ${lib.meta.getExe dotnet-runtime_8} $out/bin/vintagestory-server \
        --prefix LD_LIBRARY_PATH : "${runtimeLibs'}" \
        --set-default mesa_glthread true \
        --add-flags $out/share/vintagestory/VintagestoryServer.dll

      find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
        local filename="$(basename -- "$file")"
        ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
      done
    '';

  meta = {
    description = "In-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      artturin
      gigglesquid
      dtomvan
    ];
    mainProgram = "vintagestory";
  };
})
