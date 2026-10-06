{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs-slim,
  nix-update-script,
  makeBinaryWrapper,
  runCommand,
  vue-language-server,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vue-language-server";
  version = "3.3.11";

  src = fetchFromGitHub {
    owner = "vuejs";
    repo = "language-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a8gs53zcq5qssqnxlMGjxfZaBICisdjqkLfzqZStPfQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      src
      version
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-aUxUw3PjlSyUATb2FFQstpq+3P3ymPGZnmdiuYUQ3AE=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm
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

    find -type f \( -name "*.ts" ! -name "*.d.ts" -o -name "*.map" \) -exec rm -rf {} +

    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules packages/language-server/node_modules -xtype l -delete

    # remove non-deterministic files
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/language-tools}
    cp -r {node_modules,packages,extensions} $out/lib/language-tools/

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/vue-language-server \
      --inherit-argv0 \
      --add-flags $out/lib/language-tools/packages/language-server/bin/vue-language-server.js

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests.smoke = runCommand "vue-language-server-smoke-test" { } ''
      INIT_REQUEST='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":"file:///tmp","workspaceFolders":[{"uri":"file:///tmp","name":"test"}],"capabilities":{}}}'
      CONTENT_LENGTH=''${#INIT_REQUEST}

      RESPONSE=$(
        {
          printf "Content-Length: %d\r\n\r\n%s" "$CONTENT_LENGTH" "$INIT_REQUEST"
          sleep 1
        } | timeout 3  ${lib.getExe vue-language-server} --stdio 2>&1 | head -c 1000
      ) || true

      echo "$RESPONSE" | grep -q '"capabilities"'
      touch $out
    '';
  };

  meta = {
    description = "Official Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ friedow ];
    mainProgram = "vue-language-server";
  };
})
