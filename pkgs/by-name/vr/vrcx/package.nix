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
  pname = "vrcx";
  version = "2025.08.17";
  dotnet = dotnetCorePackages.dotnet_9;
  electron = electron_37;

  src = fetchFromGitHub {
    owner = "vrcx-team";
    repo = "VRCX";
    # v2025.08.17 tag didn't bump the version
    rev = "fa10af8acaef6ca23866cee6fc80b1b0b0038ca5";
    hash = "sha256-j/NGym4tGcazDcWtiPqxHbBCbHCkkuysd+cMUPAj6Rc=";
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

  npmDepsHash = "sha256-aFbdQhH8lQ/R+o4lCoqVc2nPJnxmNEFjR4MnqWKP32g=";
  npmFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    # need to run vue-demi postinstall for pinia
    node ./node_modules/vue-demi/scripts/postinstall.js
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
