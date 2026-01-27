{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_22,
  gitMinimal,
  gitSetupHook,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
  vtsls,
  runCommand,
}:
let
  pnpm' = pnpm_10.override { nodejs = nodejs_22; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vtsls";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    tag = "server-v${finalAttrs.version}";
    hash = "sha256-RuxaT3u9OOUMbDN6A2biIeUC+Z4leELF3OhKXxmCqbM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    nodejs_22
    # patches are applied with git during build
    gitMinimal
    gitSetupHook
    pnpmConfigHook
    pnpm'
  ];

  buildInputs = [ nodejs_22 ];

  pnpmWorkspaces = [
    "@vtsls/language-server"
    "@vtsls/language-service"
    "@vtsls/vscode-fuzzy"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pnpmWorkspaces
      pname
      src
      version
      ;
    pnpm = pnpm';
    fetcherVersion = 3;
    hash = "sha256-CWTI8uGfrUFgry3NZ9wPgmdg3yYz4SBu7wvVnR+kS6I=";
  };

  # Patches to get submodule sha from file instead of 'git submodule status'
  patches = [ ./vtsls-build-patch.patch ];

  # Skips manual confirmations during build
  CI = true;

  buildPhase = ''
    runHook preBuild

    # during build this sha is used as a marker to skip applying patches and
    # copying files, which doesn't matter in this case
    echo "dummysha" > ./packages/service/HEAD

    # Requires a git repository during build
    git init packages/service/vscode

    # Depends on the @vtsls/language-service workspace
    # '--workspace-concurrency=1' helps debug failing builds.
    pnpm --filter "@vtsls/language-server..." build

    # These trash deterministic builds. During build the whole directory is
    # copied to another path.
    rm -rf packages/service/vscode/.git
    rm -rf packages/service/src/typescript-language-features/.git

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/vtsls-language-server}
    cp -r {packages,node_modules} $out/lib/vtsls-language-server
    ln -s $out/lib/vtsls-language-server/packages/server/bin/vtsls.js $out/bin/vtsls

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests.smoke =
      runCommand "vtsls-smoke-test"
        {
        }
        ''
          INIT_REQUEST='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":"file:///tmp","workspaceFolders":[{"uri":"file:///tmp","name":"test"}],"capabilities":{}}}'
          CONTENT_LENGTH=''${#INIT_REQUEST}

          RESPONSE=$(
            {
              printf "Content-Length: %d\r\n\r\n%s" "$CONTENT_LENGTH" "$INIT_REQUEST"
              sleep 1
            } | timeout 3  ${lib.getExe vtsls} --stdio 2>&1 | head -c 1000
          ) || true

          echo "$RESPONSE" | grep -q '"capabilities"'
          touch $out
        '';
  };

  meta = {
    description = "LSP wrapper for typescript extension of vscode";
    homepage = "https://github.com/yioneko/vtsls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kuglimon ];
    mainProgram = "vtsls";
    platforms = lib.platforms.all;
  };
})
