{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  darwin,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  perl,
  electron,
  nix-update-script,
  fetchFromGitHub,
  fetchPnpmDeps,
  vikunja,
}:

let
  executableName = "vikunja-desktop";
  version = "2.6.0";
  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "vikunja";
    rev = "v${version}";
    hash = "sha256-Xh1ozUTOVqywk0i8xQWkG/bPRgPH9EABjRW8p4do1mE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  name = "vikunja-desktop-${version}";
  pname = finalAttrs.name;
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/desktop";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-RpME/0lU8i+D8erEkTfA0cXrEs8LRZvNdfU8e3X366Y=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    perl
    pnpm_10
    pnpmConfigHook
    vikunja.passthru.frontend
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  buildPhase = ''
    runHook preBuild

    sed -i "s/\$${version}/${version}/g" package.json
    sed -i "s/\"version\": \".*\"/\"version\": \"${version}\"/" package.json
    cp -r '${vikunja.passthru.frontend}' frontend
    chmod -R u+w frontend

    # Replicates step 2 of upstream's desktop/build.js: the desktop CSP is
    # script-src 'self', which blocks the inline window.API_URL script in index.html.
    perl -0pi -e 's|<script>(?:(?!</script>).)*?window\.API_URL(?:(?!</script>).)*?</script>|<script src="/api-url.js"></script>|s' frontend/index.html
    echo "window.API_URL = '''" > frontend/api-url.js

    electronDist="${electron.dist}"
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      electronDist="$(mktemp -d)"
      cp -R "${electron.dist}/." "$electronDist"
      chmod -R u+w "$electronDist"
      export CSC_IDENTITY_AUTO_DISCOVERY=false
    ''}
    pnpm run pack \
      -c.electronDist="$electronDist" \
      -c.electronVersion="${electron.version}" \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}

    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out/share/lib/vikunja-desktop"
      cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/vikunja-desktop"
      cp -r ./node_modules "$out/share/lib/vikunja-desktop/resources"

      install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/vikunja-desktop.png"

      # use makeShellWrapper (instead of the makeBinaryWrapper provided by wrapGAppsHook3) for proper shell variable expansion
      # see https://github.com/NixOS/nixpkgs/issues/172583
      makeShellWrapper "${lib.getExe electron}" "$out/bin/vikunja-desktop" \
        --add-flags "$out/share/lib/vikunja-desktop/resources/app.asar" \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications" "$out/bin"
      mv ./dist/mac*/*.app "$out/Applications"
      makeWrapper \
        "$out/Applications/Vikunja Desktop.app/Contents/MacOS/Vikunja Desktop" \
        "$out/bin/vikunja-desktop"
    ''}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      name = "vikunja-desktop";
      exec = "${executableName} %U";
      icon = "vikunja-desktop";
      terminal = false;
      desktopName = "Vikunja Desktop";
      genericName = "To-Do list app";
      comment = finalAttrs.meta.description;
      categories = [
        "ProjectManagement"
        "Office"
      ];
      mimeTypes = [
        "x-scheme-handler/vikunja-desktop"
      ];
    })
  ];

  meta = {
    description = "Desktop App of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kolaente ];
    mainProgram = "vikunja-desktop";
    inherit (electron.meta) platforms;
  };
})
