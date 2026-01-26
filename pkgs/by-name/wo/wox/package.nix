{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter338,
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
  libayatana-appindicator,
  gtk3,
  desktop-file-utils,
  xdg-utils,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "2.0.0-beta.8";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${version}";
    hash = "sha256-eucyQKNuzJCLwAnyQVE/64gth+uVrCgyHLAJNfrUxvk=";
  };

  metaCommon = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
  };

  ui-flutter = flutter338.buildFlutterApplication {
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
      fetcherVersion = 2;
      hash = "sha256-8EovIVJ+uAo9XJIIgRrpkQrcmNkKC2Ruja2md7NFZ4A=";
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
    sed -i '/^	"path"$/d' plugin/host/host_python.go
  '';

  vendorHash = "sha256-UMbhTV6fm9a2SVDsvwV1w9e4pPUhCdTi5FNVf8Rl3XM=";

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
    install -Dm644 ../assets/app.png $out/share/icons/hicolor/1024x1024/apps/wox.png
  '';

  meta = metaCommon // {
    mainProgram = "wox";
    platforms = lib.platforms.linux;
  };
}
