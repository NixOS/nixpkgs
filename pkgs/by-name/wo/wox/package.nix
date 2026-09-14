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
  libepoxy,
  libx11,
  libxkbcommon,
  libxtst,
  nodejs,
  pipewire,
  python3,
  wayland,
}:
buildGoModule (finalAttrs: {
  pname = "wox";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "Wox-launcher";
    repo = "Wox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlZHuJaI/MP35NY/39anPj1742SbV2jd8HKONqMqppI=";
  };

  vendorHash = "sha256-7j0H6VBNs6XEttJ1uW6nie7pTzcOG9QYemmHFRZWx60=";

  sourceRoot = "${finalAttrs.src.name}/wox.core";

  patches = [
    (replaceVars ./plugin-host-python.patch {
      python3-path = "${lib.getExe python3}";
      plugin-host-python = "${finalAttrs.passthru.plugin-host-python}/bin/.run-wrapped";
    })
    (replaceVars ./plugin-host-nodejs.patch {
      nodejs-path = "${lib.getExe nodejs}";
      plugin-host-nodejs = "${finalAttrs.passthru.plugin-host-nodejs}/node-host.js";
    })
  ];

  postPatch = ''
    substituteInPlace util/deeplink_linux.go \
      --replace-fail "update-desktop-database" "${desktop-file-utils}/bin/update-desktop-database" \
      --replace-fail "xdg-mime" "${xdg-utils}/bin/xdg-mime"

    substituteInPlace ui/screenshot/platform_linux_portal.go \
      --replace-fail "-I/usr/include/pipewire-0.3" "-I${pipewire.dev}/include/pipewire-0.3" \
      --replace-fail "-I/usr/include/spa-0.2" "-I${pipewire.dev}/include/spa-0.2"

    # Copy agent skills as per the `sync-ai-skills` target.
    # The program will not run if this is missing.
    mkdir -p resource/ai/skills
    cp -R ${finalAttrs.src}/.agents/skills/wox-plugin-creator resource/ai/skills
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
    libepoxy
    libx11
    libxkbcommon
    libxtst
    pipewire
    wayland
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X 'wox/util.ProdEnv=true'"
  ];

  tags = [
    "sqlite_fts5" # for file search
  ];

  preBuild = ''
    mkdir -p resource/hosts
    cp ${finalAttrs.passthru.plugin-host-nodejs}/node-host.js resource/hosts/node-host.js
    cp ${finalAttrs.passthru.plugin-host-python}/bin/.run-wrapped resource/hosts/python-host.pyz
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
  };

  meta = {
    description = "Cross-platform launcher that simply works";
    homepage = "https://github.com/Wox-launcher/Wox";
    changelog = "https://github.com/Wox-launcher/Wox/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "wox";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
