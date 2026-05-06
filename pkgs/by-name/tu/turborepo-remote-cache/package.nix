{
  lib,
  stdenvNoCC,
  nodejs-slim_24,
  pnpm_10,
  pnpmConfigHook,
  jq,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nix-update-script,
  nixosTests,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "turborepo-remote-cache";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "ducktors";
    repo = "turborepo-remote-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Wlv9BX0tZsyTvvzBEXRnPiWiC6+HQ2KDER5s3aXQ8U=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-cgsk0St0YyatC8ELHM97F9aAtMPGcYuhOhFEv8PuESQ=";
  };

  nativeBuildInputs = [
    nodejs-slim_24
    pnpmConfigHook
    pnpm_10
    jq
    makeWrapper
  ];

  postPatch = ''
    # Replace build script to skip linting
    jq '.scripts.build = "tsc -p ./tsconfig.json"' package.json > package.json.tmp
    mv package.json.tmp package.json

    # Remove prepare script since we don't need git hooks
    jq 'del(.scripts.prepare)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  buildPhase = ''
    runHook preBuild
    pnpm build
    pnpm prune --prod
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
     # Remove non-deterministic files
    rm node_modules/.modules.yaml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appdir="$out/lib/turborepo-remote-cache"
    mkdir -p "$appdir" "$out/bin"

    cp -r dist node_modules "$appdir"/

    makeWrapper ${nodejs-slim_24}/bin/node "$out/bin/turborepo-remote-cache" \
      --add-flags "$appdir/dist/index.js" \
      --set NODE_PATH "$appdir/node_modules"

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) turborepo-remote-cache; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/ducktors/turborepo-remote-cache";
    description = "This project is an open-source implementation of the Turborepo custom remote cache server.";
    license = lib.licenses.mit;
    mainProgram = "turborepo-remote-cache";
    maintainers = with lib.maintainers; [ humemm ];
  };
})
