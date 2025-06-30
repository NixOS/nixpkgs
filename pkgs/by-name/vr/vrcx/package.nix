{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  buildNpmPackage,
  electron_35,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
}:
let
  pname = "vrcx";
  version = "2025.05.09";
  dotnet = dotnetCorePackages.dotnet_9;
  electron = electron_35;

  src = fetchFromGitHub {
    owner = "vrcx-team";
    repo = "VRCX";
    tag = "v${version}";
    hash = "sha256-sqdDucjERHC5YykisFDiBOJw40snsldBcuCH1FAahSo=";
  };

  backend = buildDotnetModule {
    inherit version src;
    pname = "${pname}-backend";

    dotnet-sdk = dotnet.sdk;
    dotnet-runtime = dotnet.runtime;
    projectFile = "Dotnet/VRCX-Electron.csproj";

    nugetDeps = ./deps.json;

    installPhase = ''
      runHook preInstall

      cp -r build/Electron $out

      runHook postInstall
    '';
  };
in
buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-sXWKsW9vPyq1oK9ysJod3uAUOICsK/TBLbSekT1SO+k=";
  npmFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    env PLATFORM=linux npm exec webpack -- --config webpack.config.js --mode production
    node src-electron/patch-package-version.js
    npm exec electron-builder -- --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
    node src-electron/patch-node-api-dotnet.js

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/vrcx"
    cp -r build/*-unpacked/resources "$out/share/vrcx/"
    mkdir -p $out/share/vrcx/resources/app.asar.unpacked/build
    cp -r ${backend} "$out/share/vrcx/resources/app.asar.unpacked/build/Electron"

    makeWrapper '${electron}/bin/electron' "$out/bin/vrcx"  \
      --add-flags "--ozone-platform-hint=auto"              \
      --add-flags "$out/share/vrcx/resources/app.asar"      \
      --set NODE_ENV production                             \
      --set DOTNET_ROOT ${dotnet.runtime}/share/dotnet      \
      --prefix PATH : ${lib.makeBinPath [ dotnet.runtime ]}

    install -Dm644 VRCX.png "$out/share/icons/hicolor/256x256/apps/vrcx.png"

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
    inherit backend;
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
}
