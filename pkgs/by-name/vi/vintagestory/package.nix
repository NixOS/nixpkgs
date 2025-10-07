{
  lib,
  stdenv,
  fetchurl,
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
  dotnet-runtime_8,
}:

stdenv.mkDerivation rec {
  pname = "vintagestory";
  version = "1.21.4";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
    hash = "sha256-npffJgxgUMefX9OiveNk1r4kVqsMaVCC1jcWaibz9l8=";
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

  preFixup = ''
    makeWrapper ${dotnet-runtime_8}/bin/dotnet $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set-default mesa_glthread true \
      --add-flags $out/share/vintagestory/Vintagestory.dll

    makeWrapper ${dotnet-runtime_8}/bin/dotnet $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
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
      niraethm
      dtomvan
    ];
    mainProgram = "vintagestory";
  };
}
