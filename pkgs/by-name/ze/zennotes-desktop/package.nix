{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  electron_42,
  makeBinaryWrapper,
  nix-update-script,

  installCli ? false,
}:

buildNpmPackage (finalAttrs: {
  pname = "zennotes-desktop";
  version = "2.35.0";
  npmDepsHash = "sha256-N2boTCIA+Ca//mEVAhTeiI33GPY8NEPCBdK2xdWKl9I=";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "zennotes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q65CabiBg/azmHoJWQILThtaHcTPvdquVeyrnGh1qbg=";
  };

  npmWorkspace = "apps/desktop";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/zennotes-monorepo
    cp -r . $out/lib/node_modules/zennotes-monorepo/

    for icon in apps/desktop/build/icons/*.png; do
      size="$(basename "$icon" .png)"
      install -Dm644 $icon $out/share/icons/hicolor/$size/apps/zennotes-desktop.png
    done

    mkdir -p $out/bin
    makeWrapper ${electron_42}/bin/electron $out/bin/zennotes-desktop \
      --add-flags "$out/lib/node_modules/zennotes-monorepo/apps/desktop"

    ${lib.optionalString installCli ''
      makeWrapper ${electron_42}/libexec/electron/electron $out/bin/zn \
        --set ELECTRON_RUN_AS_NODE 1 \
        --add-flags "$out/lib/node_modules/zennotes-monorepo/apps/desktop/out/main/cli.js"
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zennotes-desktop";
      desktopName = "ZenNotes";
      exec = "zennotes-desktop %U";
      icon = "zennotes-desktop";
      comment = "Keyboard-first local Markdown notes";
      categories = [
        "Office"
        "Utility"
        "TextEditor"
      ];
      startupWMClass = "ZenNotes";
      mimeTypes = [
        "text/markdown"
        "x-scheme-handler/zennotes"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Keyboard-first local Markdown notes with Vim motions, diagrams, and MCP integration";
    homepage = "https://zennotes.org/";
    changelog = "https://github.com/ZenNotes/zennotes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      justkrysteq
      Br1ght0ne
      ad030
      showhyt
    ];
    mainProgram = "zennotes-desktop";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
