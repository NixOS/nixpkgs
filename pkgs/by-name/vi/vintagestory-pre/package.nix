{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  libx11,
  libxi,
  libxcursor,
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
  dotnet-runtime_10,
}:

stdenv.mkDerivation rec {
  pname = "vintagestory-pre";
  version = "1.22.0-pre.3";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/pre/vs_client_linux-x64_${version}.tar.gz";
    hash = "sha256-pMXBNuKO5ZAh76JkGXabN+KeRvoGGBtUN5qWDmVnT1E=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  runtimeLibs = lib.makeLibraryPath [
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
    libx11
    libxi
    libxcursor
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "vintagestory-pre";
      desktopName = "Vintage Story (Pre-release)";
      exec = "vintagestory-pre";
      icon = "vintagestory";
      comment = "Innovate and explore in a sandbox world";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vintagestory-pre $out/bin $out/share/pixmaps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory-pre
    cp $out/share/vintagestory-pre/assets/gameicon.png $out/share/pixmaps/vintagestory.png
    cp $out/share/vintagestory-pre/assets/game/fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${dotnet-runtime_10}/bin/dotnet $out/bin/vintagestory-pre \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set-default mesa_glthread true \
      --add-flags $out/share/vintagestory-pre/Vintagestory.dll

    makeWrapper ${dotnet-runtime_10}/bin/dotnet $out/bin/vintagestory-server-pre \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set-default mesa_glthread true \
      --add-flags $out/share/vintagestory-pre/VintagestoryServer.dll

    find "$out/share/vintagestory-pre/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  meta = {
    description = "In-development indie sandbox game about innovation and exploration (pre-release version)";
    homepage = "https://www.vintagestory.at/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      codyhahn
    ];
    mainProgram = "vintagestory-pre";
  };
}
