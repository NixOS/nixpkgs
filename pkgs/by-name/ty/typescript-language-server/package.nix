{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  makeWrapper,
  nodejs,
  prefetch-yarn-deps,
  replaceVars,
  yarn,
  testers,
  typescript,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "typescript-language-server";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "typescript-language-server";
    repo = "typescript-language-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5JvYTVHZUoTGokOiaJ6FF5dsNXaY7oFsWLf2doZv36Q=";
  };

  patches = [
    (replaceVars ./default-fallbackTsserverPath.diff {
      typescript = "${typescript}/lib/node_modules/typescript/lib/tsserver.js";
    })
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-05o1aOaUEL/KI5hf7dKL2lKEDxbzpg89CyR8qMi1G8s=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/typescript-language-server"
    cp -r lib node_modules package.json "$out/lib/node_modules/typescript-language-server"

    makeWrapper "${nodejs}/bin/node" "$out/bin/typescript-language-server" \
      --add-flags "$out/lib/node_modules/typescript-language-server/lib/cli.mjs"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/typescript-language-server/typescript-language-server/releases/tag/v${finalAttrs.version}";
    description = "Language Server Protocol implementation for TypeScript using tsserver";
    homepage = "https://github.com/typescript-language-server/typescript-language-server";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "typescript-language-server";
    maintainers = with lib.maintainers; [ marcel ];
  };
})
