{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  pnpm,
  pnpmConfigHook,
  nodejs,
  electron,
  nix-update-script,
  fetchFromGitHub,
  fetchPnpmDeps,
  vikunja,
}:

let
  executableName = "vikunja-desktop";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "vikunja";
    rev = "v${version}";
    hash = "sha256-R9PNhH5s3W9c1qHYmV9H5CkBvUtUFU+yzF+eEU2ybdo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  name = "vikunja-desktop-${version}";
  pname = finalAttrs.name;
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/desktop";
  pnpmInstallFlags = [ "--shamefully-hoist" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      pnpmInstallFlags
      ;
    fetcherVersion = 1;
    hash = "sha256-yiVlEr1gi2g3m+hkYfDv6qd/wRlwwknM6lAaIeR58Ok=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm
    pnpmConfigHook
    vikunja.passthru.frontend
  ];

  buildPhase = ''
    runHook preBuild

    sed -i "s/\$${version}/${version}/g" package.json
    sed -i "s/\"version\": \".*\"/\"version\": \"${version}\"/" package.json
    ln -s '${vikunja.passthru.frontend}' frontend
    pnpm run pack -c.electronDist="${electron.dist}" -c.electronVersion="${electron.version}"

    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

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

    runHook postInstall
  '';

  # Do not attempt generating a tarball for vikunja-frontend again.
  distPhase = ''
    true
  '';

  passthru.updateScript = nix-update-script { };

  # The desktop item properties should be kept in sync with data from upstream:
  desktopItem = makeDesktopItem {
    name = "vikunja-desktop";
    exec = executableName;
    icon = "vikunja";
    desktopName = "Vikunja Desktop";
    genericName = "To-Do list app";
    comment = finalAttrs.meta.description;
    categories = [
      "ProjectManagement"
      "Office"
    ];
  };

  meta = {
    description = "Desktop App of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kolaente ];
    mainProgram = "vikunja-desktop";
    inherit (electron.meta) platforms;
  };
})
