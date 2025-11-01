{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  buildNpmPackage,
  electron_37,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
}:
let
  electron = electron_37;
  dotnet = dotnetCorePackages.dotnet_9;
in
buildNpmPackage (finalAttrs: {
  pname = "vrcx";
  version = "2025.10.11";

  src = fetchFromGitHub {
    repo = "VRCX";
    owner = "vrcx-team";
    rev = "cb6bc979d9371b89b289b6cb0bb8b6f60b350bc7";
    hash = "sha256-0LnFXSLyby5b2gSIse7Qld4cQlwNAFHSuGGqk6B9TZY=";
  };

  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];
  npmDepsHash = "sha256-giWeXrsiFaZOh5zs7L4L0w3wcnD/F3TyrMM/POfOTvE=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  preBuild = ''
    # Build fails at executing dart from sass-embedded
    rm -r node_modules/sass-embedded*
  '';

  buildPhase = ''
    runHook preBuild

    env PLATFORM=linux npm exec vite build src
    node ./src-electron/patch-package-version.js
    npm exec electron-builder -- --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
    node ./src-electron/patch-node-api-dotnet.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/vrcx"
    cp -r build/*-unpacked/resources "$out/share/vrcx/"
    mkdir -p "$out/share/vrcx/resources/app.asar.unpacked/build/Electron"
    cp -r ${finalAttrs.passthru.backend}/build/Electron/* "$out/share/vrcx/resources/app.asar.unpacked/build/Electron/"

    makeWrapper '${electron}/bin/electron' "$out/bin/vrcx"  \
      --add-flags "--ozone-platform-hint=auto"              \
      --add-flags "$out/share/vrcx/resources/app.asar"      \
      --set NODE_ENV production                             \
      --set DOTNET_ROOT ${dotnet.runtime}/share/dotnet      \
      --prefix PATH : ${lib.makeBinPath [ dotnet.runtime ]}

    install -Dm644 images/VRCX.png "$out/share/icons/hicolor/256x256/apps/vrcx.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vrcx";
      desktopName = "VRCX";
      comment = "Friendship management tool for VRChat";
      icon = "vrcx";
      exec = "vrcx";
      terminal = false;
      categories = [
        "Utility"
        "Application"
      ];
      mimeTypes = [ "x-scheme-handler/vrcx" ];
    })
  ];

  passthru = {
    backend = buildDotnetModule {
      pname = "${finalAttrs.pname}-backend";
      inherit (finalAttrs) version src;

      dotnet-sdk = dotnet.sdk;
      dotnet-runtime = dotnet.runtime;
      projectFile = "Dotnet/VRCX-Electron.csproj";

      nugetDeps = ./deps.json;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/build/Electron
        cp -r build/Electron/* $out/build/Electron/

        runHook postInstall
      '';
    };
  };

  meta = {
    description = "Friendship management tool for VRChat";
    longDescription = ''
      VRCX is an assistant/companion application for VRChat that provides information about and helps you accomplish various things
      related to VRChat in a more convenient fashion than relying on the plain VRChat client (desktop or VR), or website alone.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/vrcx-team/VRCX";
    downloadPage = "https://github.com/vrcx-team/VRCX/releases";
    maintainers = with lib.maintainers; [
      ShyAssassin
      ImSapphire
    ];
    platforms = lib.platforms.linux;
    broken = !stdenv.hostPlatform.isx86_64;
  };
})
