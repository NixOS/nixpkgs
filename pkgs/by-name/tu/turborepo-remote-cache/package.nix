{
  lib,
  stdenvNoCC,
  nodejs-slim_22,
  pnpm_10,
  jq,
  fetchFromGitHub,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "turborepo-remote-cache";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "ducktors";
    repo = "turborepo-remote-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IBydX1+rPgFfgdov7pjUI7gyHBRXColcDaBOmzNNog8=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NlHQ3eJYFvZTGLzfDJPsBVlpMXOTeWdaTUukQQdLA+0=";
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
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv dist $out/dist
    mv node_modules $out/node_modules
    cp package.json $out
    # Create wrapper script
    makeWrapper ${nodejs-slim_22}/bin/node $out/bin/turborepo-remote-cache \
      --add-flags "$out/dist/index.js" \
      --set NODE_PATH "$out/node_modules"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ducktors/turborepo-remote-cache";
    description = "This project is an open-source implementation of the Turborepo custom remote cache server.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ humemm ];
  };
})
