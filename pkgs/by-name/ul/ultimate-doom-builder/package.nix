{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  msbuild,
  mono,
  libGL,
  libpng,
  libx11,
  gtk2-x11,
  makeDesktopItem,
  copyDesktopItems,
  unstableGitUpdater,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ultimate-doom-builder";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "jewalky";
    repo = "UltimateDoomBuilder";
    rev = "9d7a12b1164dc53964b594395f9d5d825a43ac12";
    hash = "sha256-FwGfrvF+UrmEw1lvcU4qL9OOP0n/ZmQTsIjQIxRvkmg=";
  };

  nativeBuildInputs = [
    msbuild
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    libGL
    libpng
    libx11
    gtk2-x11
  ];

  postPatch =
    let
      gitCommitCount = "4291";
      gitCommitHash = "9d7a12b";
    in
    ''
      # Replace git-based version generation with static values since .git directory is not available.
      # The build system runs git commands to get commit count and hash, then uses them in version strings.
      # We disable the git Exec commands and set static PropertyGroup values instead.
      for file in Source/Core/BuilderMono.csproj Source/Plugins/BuilderModes/BuilderModesMono.csproj; do
        # Remove git Exec commands (they would fail without .git directory)
        sed -i '/<Exec Command="git/,/<\/Exec>/d' "$file"
        # Replace conditional defaults with static values
        sed -i 's/>0<\/GitCommitCount>/>${gitCommitCount}<\/GitCommitCount>/g' "$file"
        sed -i 's/>0<\/GitCommitHash>/>${gitCommitHash}<\/GitCommitHash>/g' "$file"
      done
    '';

  buildPhase = ''
    runHook preBuild

    # Won't compile without windows codepage identifier for UTF-8
    msbuild /nologo /verbosity:minimal -p:Configuration=Release /p:codepage=65001 ./BuilderMono.sln

    cp builder.sh Build/builder
    chmod +x Build/builder

    # Build native library with:
    # - UDB_LINUX=1 for proper mouse input handling
    # - NO_SSE=1 on aarch64 to disable SSE intrinsics
    $CXX -std=c++14 -O2 -shared -o Build/libBuilderNative.so -fPIC \
      -DUDB_LINUX=1 \
      ${lib.optionalString stdenv.hostPlatform.isAarch64 "-DNO_SSE=1"} \
      -I Source/Native \
      Source/Native/*.cpp \
      Source/Native/OpenGL/*.cpp \
      Source/Native/OpenGL/gl_load/*.c \
      -lX11 -ldl

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/icons/hicolor/64x64/apps}

    cp -r Build $out/opt/UltimateDoomBuilder

    substituteInPlace $out/opt/UltimateDoomBuilder/builder --replace-fail mono ${mono}/bin/mono
    substituteInPlace $out/opt/UltimateDoomBuilder/builder --replace-fail Builder.exe $out/opt/UltimateDoomBuilder/Builder.exe

    # GTK is loaded dynamically by Mono at runtime
    wrapProgram $out/opt/UltimateDoomBuilder/builder \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk2-x11 ]}"

    ln -s $out/opt/UltimateDoomBuilder/builder $out/bin/ultimate-doom-builder

    cp flatpak/icons/64x64/io.github.ultimatedoombuilder.ultimatedoombuilder.png $out/share/icons/hicolor/64x64/apps/ultimate-doom-builder.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ultimate-doom-builder";
      exec = "ultimate-doom-builder";
      icon = "ultimate-doom-builder";
      desktopName = "Ultimate Doom Builder";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "Development"
        "Graphics"
        "3DGraphics"
      ];
    })
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/jewalky/UltimateDoomBuilder";
    description = "Advanced Doom map editor based on Doom Builder 2 with Mono support";
    mainProgram = "ultimate-doom-builder";
    longDescription = ''
      Ultimate Doom Builder is a map editor for Doom, Heretic, Hexen, and Strife.
      It is a continuation of Doom Builder 2 with many new features and improvements,
      including cross-platform support via Mono.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
