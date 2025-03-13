{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter327,
  keybinder3,
  nodejs,
  pnpm_9,
  python3Packages,
  writableTmpDirAsHomeHook,
  buildGoModule,
  pkg-config,
  autoPatchelfHook,
  xorg,
  libxkbcommon,
  libayatana-appindicator,
  gtk3,
  desktop-file-utils,
  xdg-utils,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "2.0.0-beta.1";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${version}";
    hash = "sha256-ghrvBOTR2v7i50OrwfwbwwFFF4uBQuEPxhXimdcFUJI=";
  };

  metaCommon = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ emaryn ];
  };

  ui-flutter = flutter327.buildFlutterApplication {
    pname = "wox-ui-flutter";
    inherit version src;

    sourceRoot = "${src.name}/wox.ui.flutter/wox";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes.window_manager = "sha256-OGVrby09QsCvXnkLdEcCoZBO2z/LXY4xFBVdRHnvKEQ=";

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ keybinder3 ];

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
      pnpm_9.configHook
    ];

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-4Xj6doUHFoZSwel+cPnr2m3rfvlxNmQCppm5gXGIEtU=";
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

  plugin-python = python3Packages.buildPythonApplication rec {
    pname = "wox-plugin";
    inherit version src;
    pyproject = true;

    sourceRoot = "${src.name}/wox.plugin.python";

    build-system = with python3Packages; [ hatchling ];

    meta = metaCommon;
  };

  plugin-host-python = python3Packages.buildPythonApplication rec {
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

  postPatch = ''
    substituteInPlace plugin/host/host_python.go \
      --replace-fail 'n.findPythonPath(ctx), path.Join(util.GetLocation().GetHostDirectory(), "python-host.pyz")' '"env", "${plugin-host-python}/bin/run"'
    substituteInPlace plugin/host/host_nodejs.go \
      --replace-fail "/usr/bin/node" "${lib.getExe nodejs}"
    substituteInPlace util/deeplink.go \
      --replace-fail "update-desktop-database" "${desktop-file-utils}/bin/update-desktop-database" \
      --replace-fail "xdg-mime" "${xdg-utils}/bin/xdg-mime" \
      --replace-fail "Exec=%s" "Exec=wox"
  '';

  vendorHash = "sha256-n3lTx1od4EvWdTSe3sIsUStp2qcuSWMqztJZoNLrzQg=";

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXtst
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
    install -Dm644 ../assets/app.png $out/share/pixmaps/wox.png
  '';

  meta = metaCommon // {
    mainProgram = "wox";
    platforms = lib.platforms.linux;
  };
}
