{
  lib,
  buildNpmPackage,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  fetchFromGitHub,
  turbo,
  runCommand,
  jq,
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

  patchedPackageJSON = runCommand "package.json" { nativeBuildInputs = [ jq ]; } ''
    jq '
    . += {"bin": "apps/server/dist/index.js" }
    ' ${src}/package.json > $out
  '';

  postPatch = ''
    cp ${patchedPackageJSON} ./package.json
  '';

  npmConfigHook = pnpmConfigHook;

  npmDeps = pnpmDeps;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-lkA9eYuOc1J+tUM1Bd57ROsT8es6AAMjHB5AyoN7oqg=";
  };
  strictDeps = true;

  npmPackFlags = [ "--ignore-scripts" ];
  dontNpmPrune = true;

  env.NODE_ENV = "production";

  nativeBuildInputs = [
    makeWrapper
    pnpm_10
    turbo
  ];

  npmBuildScript = "build";

  makeWrapperArgs = [ "--set NODE_PATH $out/lib/node_modules/tracearr/node_modules" ];

  meta = {
    description = "Real-time monitoring for Plex, Jellyfin, and Emby servers. Track streams, analyze playback, and detect account sharing from a single dashboard.";
    mainProgram = "tracearr";
    homepage = "https://tracearr.com";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ethnt ];
  };
})
