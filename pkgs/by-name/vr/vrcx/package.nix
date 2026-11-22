{
  lib,
  stdenv,
  nodejs_24,
  electron_44,
  makeWrapper,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,
  buildDotnetModule,
  dotnetCorePackages,
}:
let
  node = nodejs_24;
  electron = electron_44;
  dotnet = dotnetCorePackages.dotnet_10;
in
buildNpmPackage (finalAttrs: {
  pname = "vrcx";
  version = "2026.11.14";

  src = fetchFromGitHub {
    repo = "VRCX";
    owner = "vrcx-team";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/SPc0VAE50yHsYNEfeEuf3BfexgEKOvAUOLcrK7yQW8=";
  };

  nodejs = node;
  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];
  npmDepsHash = "sha256-VEB+BS54jMhMi3GXmF9tNH/1ahTZn7FSy27zOAhaVqU=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postPatch = ''
    # VRCX's upstream lockfile lacks `integirty` and `resolved` fields
    # annoying but can be trivially fixed by cloning the vrcx repo locally then
    # regenerating the lockfile with `nix run nixpkgs#npm-lockfile-fix -- package-lock.json`
    cp ${./package-lock.json} package-lock.json
  '';

  buildPhase = ''
    runHook preBuild

    env PLATFORM=linux npm exec vite build src
    node ./build-scripts/patch-package-version.js
    npm exec electron-builder -- \
      --config electron-builder.config.js \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/vrcx"
    cp -r build/*-unpacked/resources "$out/share/vrcx/"
    mkdir -p "$out/share/vrcx/resources/app.asar.unpacked/build/Electron"
    cp -r ${finalAttrs.passthru.backend}/build/Electron/* "$out/share/vrcx/resources/app.asar.unpacked/build/Electron/"

    makeWrapper '${electron}/bin/electron' "$out/bin/vrcx"  \
      --add-flags "--ozone-platform-hint=auto --no-updater" \
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
      icon = "vrcx";
      exec = "vrcx %u";
      terminal = false;
      desktopName = "VRCX";
      comment = "Friendship management tool for VRChat";
      categories = [
        "Utility"
        "Application"
      ];
      mimeTypes = [ "x-scheme-handler/vrcx" ];
    })
  ];

  passthru = {
    backend = buildDotnetModule {
      inherit (finalAttrs) version src;
      pname = "${finalAttrs.pname}-backend";

      dotnet-sdk = dotnet.sdk;
      dotnet-runtime = dotnet.runtime;
      dotnetFlags =
        let
          platformName = if stdenv.hostPlatform.isx86_64 then "x64" else "ARM64";
        in
        [
          "-p:RuntimeIdentifier=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}"
          "-p:Platform=${platformName}"
        ];
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    broken = !stdenv.hostPlatform.isx86_64;
  };
})
