{
  lib,
  fetchFromGitHub,
  callPackage,
  buildGoModule,
  replaceVars,

  # build-time
  autoPatchelfHook,
  copyDesktopItems,
  desktop-file-utils,
  makeDesktopItem,
  pkg-config,
  xdg-utils,

  # run-time
  gtk3,
  libayatana-appindicator,
  libx11,
  libxkbcommon,
  libxtst,
  nodejs,
}:
buildGoModule (finalAttrs: {
  pname = "wox";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FbOnENSko/BYtTI7z2Ep+IIYufgZpNWcz6d0mqhTL5g=";
  };

  vendorHash = "sha256-IDcIEZVCJp1ls5c2fblgX+I+MhfRDXqFbf0GhgcFiTo=";

  sourceRoot = "${finalAttrs.src.name}/wox.core";

  patches = [
    (replaceVars ./plugin-host-python.patch {
      plugin-host-python = "${finalAttrs.passthru.plugin-host-python}/bin/run";
    })
    (replaceVars ./plugin-host-nodejs.patch {
      nodejs-path = "${lib.getExe nodejs}";
      plugin-host-nodejs = "${finalAttrs.passthru.plugin-host-python}/node-host.js";
    })
  ];

  postPatch = ''
    substituteInPlace util/deeplink.go \
      --replace-fail "update-desktop-database" "${desktop-file-utils}/bin/update-desktop-database" \
      --replace-fail "xdg-mime" "${xdg-utils}/bin/xdg-mime"
  '';

  proxyVendor = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    libx11
    libxkbcommon
    libxtst
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
    changelog = "https://github.com/Wox-launcher/Wox/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "wox";
    platforms = lib.platforms.linux;
    license = with lib.licenses; gpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
