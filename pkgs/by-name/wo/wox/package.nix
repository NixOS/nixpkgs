{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter341,
  keybinder3,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3Packages,
  writableTmpDirAsHomeHook,
  buildGoModule,
  pkg-config,
  autoPatchelfHook,
  libxtst,
  libx11,
  libxkbcommon,
  xorgproto,
  libayatana-appindicator,
  gtk3,
  desktop-file-utils,
  xdg-utils,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${version}";
    hash = "sha256-jiid8emFUN7554ijyL5jTvaQPNz+1rO6IwBMrqdkm4I=";
  };

  metaCommon = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
  };

  ui-flutter = flutter341.buildFlutterApplication {
    pname = "wox-ui-flutter";
    inherit version src;

    sourceRoot = "${src.name}/wox.ui.flutter/wox";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = {
      extended_text_field = "sha256-GOvaWGklfmJKRWYbVTvpZfKj9QMxxlaqrJkfDKR2T0o=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      keybinder3
      xorgproto
      libx11
      libxtst
    ];

    meta = metaCommon // {
      mainProgram = "wox";
      platforms = lib.platforms.linux;
    };
  };

  plugin-host-nodejs = stdenv.mkDerivation (finalAttrs: {
    pname = "wox-plugin-host-nodejs";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/wox.plugin.host.nodejs";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-h5Ju98qnhUmrkjTzv6T5gsOA+1mIXJwyzkqLHQAI6pU=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm644 dist/index.js $out/node-host.js

      runHook postInstall
    '';

    meta = metaCommon;
  });

  plugin-python = python3Packages.buildPythonApplication {
    pname = "wox-plugin";
    inherit version src;
    pyproject = true;

    sourceRoot = "${src.name}/wox.plugin.python";

    build-system = with python3Packages; [ hatchling ];

    meta = metaCommon;
  };

  plugin-host-python = python3Packages.buildPythonApplication {
    pname = "wox-plugin-host-python";
    inherit version src;
    pyproject = true;

    sourceRoot = "${src.name}/wox.plugin.host.python";

    build-system = with python3Packages; [ hatchling ];

    nativeBuildInputs = [ writableTmpDirAsHomeHook ];

    buildInputs = with python3Packages; [
      loguru
      websockets
      plugin-python
    ];

    dependencies = with python3Packages; [
      loguru
      websockets
      plugin-python
    ];

    meta = metaCommon // {
      mainProgram = "run";
    };
  };
in
buildGoModule {
  pname = "wox";
  inherit version src;

  sourceRoot = "${src.name}/wox.core";

  patches = [
    ./host_python.patch
    ./host_nodejs.patch
    ./deeplink.patch
  ];

  postPatch = ''
    substituteInPlace plugin/host/host_python.go \
      --replace-fail '@pluginHostPython@' '${plugin-host-python}/bin/run'
    substituteInPlace plugin/host/host_nodejs.go \
      --replace-fail '@nodejs@' '${lib.getExe nodejs}'
    substituteInPlace util/deeplink.go \
      --replace-fail '@xdgUtils@' '${xdg-utils}/bin/xdg-mime' \
      --replace-fail '@desktopFileUtils@' '${desktop-file-utils}/bin/update-desktop-database'
  '';

  vendorHash = "sha256-IDcIEZVCJp1ls5c2fblgX+I+MhfRDXqFbf0GhgcFiTo=";

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxtst
    libxkbcommon
    libayatana-appindicator
    gtk3
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X 'wox/util.ProdEnv=true'"
  ];

  preBuild = ''
    mkdir -p resource/ui/flutter resource/hosts
    cp -r ${ui-flutter}/app/${ui-flutter.pname} resource/ui/flutter/wox
    cp ${plugin-host-nodejs}/node-host.js resource/hosts/node-host.js
  '';

  # XOpenDisplay failure!
  # XkbGetKeyboard failed to locate a valid keyboard!
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "wox";
      exec = "wox %U";
      icon = "wox";
      desktopName = "Wox";
    })
  ];

  postInstall = ''
    install -Dm644 ../assets/app.png $out/share/icons/wox.png
  '';

  meta = metaCommon // {
    mainProgram = "wox";
    platforms = lib.platforms.linux;
  };
}
