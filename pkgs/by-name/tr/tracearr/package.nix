{
  lib,
  buildNpmPackage,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  nodejs,
  fetchFromGitHub,
  turbo,
}:
buildNpmPackage (finalAttrs: rec {
  pname = "tracearr";
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "connorgallopo";
    repo = "Tracearr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KE/kMB620+Eksq21uaqzEeoQVIlJN2cEEkJVh9/ccBE=";
  };

  npmConfigHook = pnpmConfigHook;

  npmDeps = pnpmDeps;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-lkA9eYuOc1J+tUM1Bd57ROsT8es6AAMjHB5AyoN7oqg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pnpm_10
    turbo
  ];

  env.NODE_ENV = "production";

  npmBuildScript = "build";

  makeWrapperArgs = [ "--add-flags $out/share/tracearr/apps/server/dist/index.js" ];

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{share/tracearr,bin}
    cp -r {node_modules,apps,packages,data} $out/share/tracearr
    makeWrapper ${lib.getExe nodejs} $out/bin/tracearr \
      --add-flags $out/share/tracearr/apps/server/dist/index.js \
      --set NODE_PATH "$out/share/tracearr/node_modules:$out/share/tracearr/apps/server/node_modules:$out/share/tracearr/apps/web/node_modules"
    find $out/share -xtype l -delete
    runHook postInstall
  '';

  meta = {
    description = "Real-time monitoring for Plex, Jellyfin, and Emby servers. Track streams, analyze playback, and detect account sharing from a single dashboard.";
    mainProgram = "tracearr";
    homepage = "https://tracearr.com";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ethnt ];
  };
})
