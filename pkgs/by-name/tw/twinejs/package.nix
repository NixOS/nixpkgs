{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  jq,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "twine";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "klembot";
    repo = "twinejs";
    tag = finalAttrs.version;
    hash = "sha256-+y25XxTRxmCKjNL74Wb3hgAkw8yQNznYNzTuDL3uIvg=";
  };

  npmDepsHash = "sha256-9gMdbFibt6RwMxEsBAQE7nM0rfE7PqgUxTs87+g0Ok8=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  nativeBuildInputs = [
    jq
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildPhase = ''
    runHook preBuild

    npm run build:web
    npm run build:electron-main

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    files="$(node -e 'process.stdout.write(require("./electron-builder.config.js").files.join(" "))')"
    packageJson="$(jq -s '.[0] * .[1]' package.json <(node -e 'process.stdout.write(JSON.stringify(require("./electron-builder.config.js").extraMetadata))'))"

    # so that dev dependencies will not be installed
    npm prune --production

    phome="$out/lib/node_modules/$(jq -r .name package.json)"
    mkdir -p "$phome"
    tar -cf - --wildcards $files | tar -C "$phome" -xf -
    echo "$packageJson" > "$phome/package.json"

    makeWrapper ${lib.getExe electron} $out/bin/twine \
      --add-flags "$phome" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    install -Dm644 icons/app-pwa.svg $out/share/icons/hicolor/scalable/apps/twine.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "twine";
      desktopName = "Twine";
      comment = finalAttrs.meta.description;
      exec = "twine %U";
      icon = "twine";
      categories = [ "Development" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source tool for telling interactive, nonlinear stories";
    homepage = "https://twinery.org";
    changelog = "https://github.com/klembot/twinejs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = electron.meta.platforms;
    mainProgram = "twine";
  };
})
