{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  nix-update-script,
  makeBinaryWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vue-language-server";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "vuejs";
    repo = "language-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oiQUEUBOZrTB7BhRmc4HEGTpbOGGSCiTlO/Cn0sBNtU=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-BKiTGANch9phNN+zVpPzA+E4MtpM/G3yLiEQObtKLmI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build packages/language-server
    runHook postBuild
  '';

  preInstall = ''
    # the mv commands are workaround for https://github.com/pnpm/pnpm/issues/8307
    mv packages packages.dontpruneme
    CI=true pnpm prune --prod
    find packages.dontpruneme/**/node_modules -xtype l -delete
    mv packages.dontpruneme packages

    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +

    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules packages/language-server/node_modules -xtype l -delete

    # remove non-deterministic files
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/language-tools}
    cp -r {node_modules,packages,extensions} $out/lib/language-tools/

    makeWrapper ${lib.getExe nodejs} $out/bin/vue-language-server \
      --inherit-argv0 \
      --add-flags $out/lib/language-tools/packages/language-server/bin/vue-language-server.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ friedow ];
    mainProgram = "vue-language-server";
  };
})
