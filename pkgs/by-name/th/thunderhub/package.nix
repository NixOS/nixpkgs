{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs_22,
  nix-update-script,
  # Vite embeds this prefix in the frontend, so it must also be set at runtime.
  basePath ? "",
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "thunderhub";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "apotdevin";
    repo = "thunderhub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OG9uDBP9jIFAV+U7dQn/FXXMTulz87VRspCwV6nBtNk=";
  };

  npmDepsHash = "sha256-27q1ikm88s5pawqPktNUZVzz/bm3uEuefrJJWQFLLo8=";
  # The GraphQL playground plugin still declares Apollo Server 4 as a peer.
  npmFlags = [ "--legacy-peer-deps" ];
  # Node.js 24.19+ crashes when garbage-collecting better-sqlite3 statements.
  # https://github.com/nodejs/node/issues/65446
  nodejs = nodejs_22;

  nativeBuildInputs = [ makeWrapper ];

  env = {
    BASE_PATH = basePath;
    HUSKY = "0";
    # Build native addons without downloading prebuilt binaries.
    npm_config_build_from_source = "true";
  };

  preBuild = ''
    # Find bundled assets independently of the working directory, which is
    # still used for .env.local and relative configuration and database paths.
    substituteInPlace \
      src/server/app.module.ts \
      src/server/config/configuration.ts \
      src/server/modules/database/drizzle.provider.ts \
      --replace-fail 'process.cwd()' "'$out/lib/thunderhub'"
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm test -- --runInBand

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --ignore-scripts $npmFlags

    mkdir -p $out/lib/thunderhub/src/client
    cp -r dist drizzle node_modules package.json $out/lib/thunderhub
    cp -r src/client/dist $out/lib/thunderhub/src/client
    install -Dm644 LICENSE $out/share/licenses/thunderhub/LICENSE

    makeWrapper ${lib.getExe nodejs_22} $out/bin/thunderhub \
      --set NODE_ENV production \
      --set BASE_PATH ${lib.escapeShellArg basePath} \
      --add-flags "$out/lib/thunderhub/dist/main.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web interface for managing Lightning Network nodes";
    homepage = "https://thunderhub.io";
    changelog = "https://github.com/apotdevin/thunderhub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    mainProgram = "thunderhub";
    platforms = lib.platforms.unix;
  };
})
