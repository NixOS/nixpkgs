{
  stdenv,
  fetchYarnDeps,
  fixup-yarn-lock,
  callPackage,
  nodejs_20,
  yarn,
}:
let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tandoor-recipes-frontend";
  inherit (common) version;

  src = "${common.src}/vue3";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = common.yarnHash;
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs_20
    (yarn.override { nodejs = nodejs_20; })
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    command -v yarn
    yarn install --frozen-lockfile --offline --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ../cookbook/static/vue3/ $out
    echo "${common.version}" > "$out/version"

    runHook postInstall
  '';

  meta = common.meta // {
    description = "Tandoor Recipes frontend";
  };
})
