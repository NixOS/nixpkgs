{
  lib,
  fetchFromGitHub,
  callPackage,
  nodejs,
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
buildGoModule (finalAttrs: {
  pname = "wox";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qav2RhmhJQr2D1D3okshIrnnQuOh7V1gWbZwXR3LBAc=";
  };

  sourceRoot = "${finalAttrs.src.name}/wox.core";

  postPatch = ''
    substituteInPlace plugin/host/host_python.go \
      --replace-fail \
        'n.findPythonPath(ctx), path.Join(util.GetLocation().GetHostDirectory(), "python-host.pyz")' \
        '"env", "${finalAttrs.passthru.plugin-host-python}/bin/run"'
    substituteInPlace plugin/host/host_nodejs.go \
      --replace-fail "/usr/bin/node" "${lib.getExe nodejs}"
    substituteInPlace util/deeplink.go \
      --replace-fail "update-desktop-database" "${desktop-file-utils}/bin/update-desktop-database" \
      --replace-fail "xdg-mime" "${xdg-utils}/bin/xdg-mime" \
      --replace-fail "Exec=%s" "Exec=wox"
    sed -i '/^	"path"$/d' plugin/host/host_python.go
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
    cp -r ${finalAttrs.passthru.ui-flutter}/app/${finalAttrs.passthru.ui-flutter.pname} resource/ui/flutter/wox
    cp ${finalAttrs.passthru.plugin-host-nodejs}/node-host.js resource/hosts/node-host.js
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

  passthru = {
    plugin-host-nodejs = callPackage ./plugin-host-nodejs.nix { };
    plugin-host-python = callPackage ./plugin-host-python.nix { };
    ui-flutter = callPackage ./ui-flutter.nix { };
  };

  meta = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    mainProgram = "wox";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
  };
})
