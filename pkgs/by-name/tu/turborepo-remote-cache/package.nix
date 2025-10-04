{
  lib,
  stdenvNoCC,
  nodejs-slim_22,
  pnpm_10,
  jq,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "turborepo-remote-cache";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ducktors";
    repo = "turborepo-remote-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-86uEO/2aWWiIRIdpESFQGpq6nHtGLqp4ZlNeeGFUGCY=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-q1Nn7u8mOoD0niKGAsQXl8saUNWyhfaMhsOaQa4EGeg=";
  };

  nativeBuildInputs = [
    nodejs-slim_22
    pnpm_10.configHook
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

    makeWrapper ${nodejs-slim_22}/bin/node "$out/bin/turborepo-remote-cache" \
      --add-flags "$appdir/dist/index.js" \
      --set NODE_PATH "$appdir/node_modules"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/ducktors/turborepo-remote-cache";
    description = "This project is an open-source implementation of the Turborepo custom remote cache server.";
    license = lib.licenses.mit;
    mainProgram = "turborepo-remote-cache";
    maintainers = with lib.maintainers; [ humemm ];
  };
})
