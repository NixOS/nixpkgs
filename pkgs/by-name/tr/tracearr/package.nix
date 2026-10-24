{
  lib,
  stdenv,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  nodejs-slim_22,
  fetchFromGitHub,
  turbo,
  nix-update-script,
}:
let
  pnpm = pnpm_12.override { nodejs-slim = nodejs-slim_22; };
  nodejs = nodejs-slim_22;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tracearr";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "connorgallopo";
    repo = "Tracearr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r0hfoZn005oEjxP32hUW+rqztkEHXHOTbfTEEUDN9yU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-u1/mfBG+IxXQdKaTdCWeIwGKl4Eo1aMq7uMhachfef4=";
  };

  strictDeps = true;

  env.NODE_ENV = "production";

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm
    turbo
  ];

  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild

    turbo build --env-mode=loose

    runHook postBuild
  '';

  doCheck = false;

  checkPhase = ''
    runHook preCheck

    turbo test --env-mode=loose

    runHook postCheck
  '';

  preInstall = ''
    find . -type f \( -name "*.d.ts" -o -name "*.map" \) -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib/tracearr/apps,bin}

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
