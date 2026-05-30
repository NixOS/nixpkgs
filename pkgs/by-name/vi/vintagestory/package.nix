{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  versionCheckHook,
  cairo,
  libGLU,
  libglvnd,
  pipewire,
  libpulseaudio,
  dotnet-runtime_10,
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
  version = "1.22.2";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${finalAttrs.version}.tar.gz";
    hash = "sha256-caLSOm/WXpXrjC1az72Nc0XDWOpWB2R9iVq8ShDEZgU=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
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

    mkdir -p $out/share/vintagestory $out/bin $out/share/icons/hicolor/512x512/apps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory
    install -Dm444 $out/share/vintagestory/assets/gameicon.png $out/share/icons/hicolor/512x512/apps/vintagestory.png
    cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

    rm -rvf $out/share/vintagestory/{install,run,server}.sh

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--set-default"
    "mesa_glthread"
    "true"
  ]
  ++ lib.optionals waylandSupport [
    "--set-default"
    "OPENTK_4_USE_WAYLAND"
    "1"
  ];

  runtimeLibraryPath = lib.makeLibraryPath finalAttrs.passthru.runtimeLibs;
  preFixup = ''
     makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$runtimeLibraryPath")

     makeWrapper ${lib.meta.getExe dotnet-runtime_10} $out/bin/vintagestory \
      "''${makeWrapperArgs[@]}" \
       --add-flags $out/share/vintagestory/Vintagestory.dll

    makeWrapper ${lib.getExe dotnet-runtime_10} $out/bin/vintagestory-server \
      "''${makeWrapperArgs[@]}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.dll

     find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
       local filename="$(basename -- "$file")"
       ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
     done
  '';

  doInstallCheck = true;
  installCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = ./update.sh;
    runtimeLibs = [
      cairo
      libGLU
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
  };

  meta = {
    description = "In-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      artturin
      gigglesquid
      dtomvan
    ];
    mainProgram = "vintagestory";
  };
})
