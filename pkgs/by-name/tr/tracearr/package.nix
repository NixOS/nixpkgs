{
  lib,
  stdenv,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  nix-update-script,
  nodejs,
  fetchFromGitHub,
  turbo,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tracearr";
  version = "1.4.27";

  src = fetchFromGitHub {
    owner = "connorgallopo";
    repo = "Tracearr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AIybXQFRrD5H5aF77ykL0xpYs/UftAAJVyo84LTdTdw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-mBo2+Gy91MQEplMDSkExb9eKmOGeDYk8c4uHMzjDv64=";
  };

  strictDeps = true;

  env.NODE_ENV = "production";

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
    turbo
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    pnpm test

    runHook postCheck
  '';

  preInstall = ''
    rm node_modules/.modules.yaml

    CI=true pnpm prune --prod --ignore-scripts

    find -type f \( -name "*.d.ts" -o -name "*.map" \) -exec rm -rf {} +
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib/tracearr,bin}
    mkdir -p $out/lib/tracearr/apps

    cp -r {node_modules,packages,data} $out/lib/tracearr
    cp -r apps/{server,web} $out/lib/tracearr/apps

    makeWrapper ${lib.getExe nodejs} $out/bin/tracearr \
      --add-flags $out/lib/tracearr/apps/server/dist/index.js \
      --set NODE_PATH "$out/lib/tracearr/node_modules:$out/lib/tracearr/apps/server/node_modules:$out/lib/tracearr/apps/web/node_modules" \
      --set-default APP_VERSION ${finalAttrs.version} \
      --set-default APP_TAG v${finalAttrs.version} \
      --set-default NODE_ENV production

    runHook postInstall
  '';

  postInstall = ''
    find $out/lib -xtype l -delete
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Real-time monitoring for Plex, Jellyfin, and Emby servers. Track streams, analyze playback, and detect account sharing from a single dashboard.";
    mainProgram = "tracearr";
    homepage = "https://tracearr.com";
    license = lib.licenses.unfree; # Marked unfree due to licensing issues upstream: https://github.com/connorgallopo/Tracearr/issues/702
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ethnt ];
  };
})
