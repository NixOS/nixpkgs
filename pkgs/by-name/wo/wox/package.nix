{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter335,
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
  version = "2.0.0-beta.5";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${version}";
    hash = "sha256-ZuKsIWooLqGeEex8uRiMVYVxnAJyiQt0soZ9OP6+qq0=";
  };

  metaCommon = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
  };

  ui-flutter = flutter335.buildFlutterApplication {
    pname = "wox-ui-flutter";
    inherit version src;

    sourceRoot = "${src.name}/wox.ui.flutter/wox";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

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
      fetcherVersion = 2;
      hash = "sha256-HhdMwVNt7178EQlZGpTiTySBp8GR9tBpUaikEWt1BGY=";
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

  vendorHash = "sha256-Ft4X2woSf0ib0Z8dAwf0VAFQv0ck9nVs7EnpWgGi2+0=";

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
    install -Dm644 ../assets/app.png $out/share/icons/hicolor/1024x1024/apps/wox.png
  '';

  meta = metaCommon // {
    mainProgram = "wox";
    platforms = lib.platforms.linux;
  };
}
