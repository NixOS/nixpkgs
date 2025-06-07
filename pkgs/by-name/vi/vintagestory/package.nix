{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  xorg,
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
  dotnet-runtime_7,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vintagestory";
  version = "1.20.12";

  src = fetchzip {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${finalAttrs.version}.tar.gz";
    hash = "sha256-GlxBpnQBk1yZfh/uPK83ODrwn/VoORA3gGkvcXy+nV8=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  runtimeLibs = lib.makeLibraryPath (
    [
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
    ++ (with xorg; [
      libX11
      libXi
      libXcursor
    ])
  );

  desktopItems = [
    (makeDesktopItem {
      name = "vintagestory";
      desktopName = "Vintage Story";
      exec = "vintagestory";
      icon = "vintagestory";
      comment = "Innovate and explore in a sandbox world";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vintagestory $out/bin $out/share/pixmaps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory
    cp $out/share/vintagestory/assets/gameicon.xpm $out/share/pixmaps/vintagestory.xpm
    cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

    rm -rvf $out/share/vintagestory/{install,run,server}.sh

    runHook postInstall
  '';

  preFixup =
    let
      wrapperFlags = lib.trim ''
        --prefix LD_LIBRARY_PATH : "${finalAttrs.runtimeLibs}" \
        --set-default mesa_glthread true
      '';
    in
    ''
      makeWrapper ${lib.getExe dotnet-runtime_7} $out/bin/vintagestory \
        ${wrapperFlags} \
        --add-flags $out/share/vintagestory/Vintagestory.dll

      makeWrapper ${lib.getExe dotnet-runtime_7} $out/bin/vintagestory-server \
        ${wrapperFlags} \
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
      niraethm
      dtomvan
    ];
    mainProgram = "vintagestory";
  };
})
