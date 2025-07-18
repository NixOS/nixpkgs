{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  yarn-berry_4,
  faketty,
  node-gyp,
  python3,
  pkg-config,
  pixman,
  cairo,
  pango,
  vips,
  makeWrapper,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "twenty";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "twentyhq";
    repo = "twenty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0k/AQHs8n8HX9bmFzjmP9eODqkkBJjCe5a76W+sOwnY=";
  };

  patches = [
    # treeverse 1.0.4 produces a hash mismatch in fetchYarnBerryDeps,
    # but 3.0.0 is API compatible and only drops support for old nodejs versions.
    ./0001-treeverse-dep.patch
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    makeWrapper
    # nx requires a pseudo TTY to function, see https://github.com/nrwl/nx/issues/22445
    faketty
    # required for native addons
    node-gyp
    python3
    pkg-config
  ];

  buildInputs = [
    # required by node-canvas
    pixman
    cairo
    pango
    # required by sharp
    vips
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches missingHashes;
    hash = "sha256-loIknpIrKViPgr0Hzp0YmfiYXuNT7DYhCUyxr4jwD0k=";
  };

  # Requires network access
  env.YARN_ENABLE_HARDENED_MODE = "0";

  buildPhase = ''
    runHook preBuild

    # Build backend
    faketty yarn nx run twenty-server:build
    # Following tasks overwrites dist, so we have to back it up
    mv packages/twenty-server/{dist,build}

    # Build production package.json
    faketty yarn nx run twenty-server:build:packageJson
    mv packages/twenty-server/{dist/,}package.json
    # Restore backend dist
    rm -r packages/twenty-server/dist
    mv packages/twenty-server/{build,dist}

    # Build frontend
    faketty yarn nx build twenty-front
    mv packages/{twenty-front/build,twenty-server/dist/front}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Pruning development dependencies also removes the constraints checking dependencies,
    # so we must disable constraints checks before.
    substituteInPlace .yarnrc.yml \
      --replace-fail "enableConstraintsChecks: true" "enableConstraintsChecks: false"
    yarn workspaces focus --production twenty-emails twenty-shared twenty-server

    mkdir -p $out/lib/packages
    mv node_modules $out/lib/
    mv packages/{twenty-emails,twenty-shared,twenty-server} $out/lib/packages/

    makeWrapper "${lib.getExe nodejs}" "$out/bin/twenty-server" \
      --add-flags "$out/lib/packages/twenty-server/dist/src/main.js" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    inherit (nodejs.meta) platforms broken;
    description = "Modern, powerful, affordable platform to manage your customer relationships";
    homepage = "https://github.com/twentyhq/twenty";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "twenty-server";
  };
})
