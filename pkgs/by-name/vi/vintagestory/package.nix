{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  versionCheckHook,
  xorg,
  cairo,
  libGLU,
  libglvnd,
  pipewire,
  libpulseaudio,
  dotnet-runtime_8,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vintagestory";
  version = "1.21.5";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${finalAttrs.version}.tar.gz";
    hash = "sha256-dG1D2Buqht+bRyxx2ie34Z+U1bdKgi5R3w29BG/a5jg=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  runtimeLibs = lib.makeLibraryPath (
    [
      cairo
      libGLU
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

    rm -rvf $out/share/vintagestory/{install,run,server}.sh

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--set-default"
    "mesa_glthread"
    "true"
  ];

  preFixup = ''
    makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : ''${runtimeLibs[*]})
    makeWrapper ${lib.getExe dotnet-runtime_8} $out/bin/vintagestory \
      "''${makeWrapperArgs[@]}" \
      --add-flags $out/share/vintagestory/Vintagestory.dll

    makeWrapper ${lib.getExe dotnet-runtime_8} $out/bin/vintagestory-server \
      "''${makeWrapperArgs[@]}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.dll

    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  doInstallCheck = true;
  installCheckInputs = [ versionCheckHook ];

  meta = {
    description = "In-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      artturin
      gigglesquid
      niraethm
      dtomvan
    ];
    mainProgram = "vintagestory";
  };
})
