{
  fetchPnpmDeps,
  lib,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  stdenv,
  gitMinimal,
  fetchFromGitHub,
  electron,
  makeWrapper,
  buildGoModule,
  wayland,
  awww,
  feh,
}:
let
  pnpm = pnpm_11;

  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "0bCdian";
    repo = "Waypaper-Engine";
    tag = "v${version}";
    hash = "sha256-oee44RABW+0BcirsJbc5WnLVQeyAamXfxj4Q1x4B2JA=";
  };

  backend = buildGoModule (finalAttrs: {
    pname = "waypaper-daemon";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/daemon";

    patches = [
      ./0002-fix-awww-require-WAYLAND_DISPLAY.patch
      ./0003-fix-core-persist-active-backend-config-when-already.patch
    ];

    patchFlags = [ "-p2" ];

    buildInputs = [ wayland ];

    proxyVendor = true;
    vendorHash = "sha256-KGyaZhWU5UOPV73MitA5eycy3ugH+rwgNu09r3ALtIo=";

    subPackages = [ "cmd/daemon" ];

    ldflags = [
      "-s"
      "-X main.version=${version}"
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "waypaper-engine";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
    gitMinimal
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-m/TtZ1rUXyzSYfxDMuZGW8d0Rl6T7qU+v4kRHAa6PM0=";
  };

  patchPhase = ''
    # binary patch unsupported by patch command, requires git apply
    git apply ${./0001-fix-null-strings.patch}
  '';

  buildPhase = ''
    runHook preBuild

    substituteInPlace globals/configReader.ts \
      --replace-fail "process.resourcesPath" "\"$out/bin\""

    pnpm exec vite build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mkdir -p $out/bin $out/share/applications $out/libexec/waypaper-engine/apps/desktop

    cp -r node_modules $out/libexec/waypaper-engine
    cp -r dist $out/libexec/waypaper-engine/apps/desktop
    cp -r dist-electron $out/libexec/waypaper-engine/apps/desktop

    for size in 16x16 32x32 64x64 128x128 256x256 512x512; do
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      cp "build/icons/$size.png" "$out/share/icons/hicolor/$size/apps/waypaper-engine.png"
    done

    cp waypaper-engine.desktop $out/share/applications

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/waypaper-engine \
      --add-flags $out/libexec/waypaper-engine/apps/desktop/dist-electron/main.js

    makeWrapper ${finalAttrs.passthru.backend}/bin/daemon $out/bin/waypaper-daemon \
      --prefix PATH : ${
        lib.makeBinPath [
          awww
          feh
        ]
      }
  '';

  passthru = { inherit backend; };

  meta = {
    description = "Wallpaper setter GUI with playlist functionality for Wayland and X11";
    longDescription = ''
      Waypaper Engine is a wallpaper manager with playlist support, advanced filters, multiple backend support, and Wallhaven integration.
    '';
    homepage = "https://github.com/0bCdian/Waypaper-Engine";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/0bCdian/Waypaper-Engine/releases/tag/${finalAttrs.src.rev}";
    maintainers = with lib.maintainers; [
      zainkergaye
      phanirithvij
    ];
    platforms = lib.platforms.linux;
    mainProgram = "waypaper-engine";
  };
})
