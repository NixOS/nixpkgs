{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_22,
  gitMinimal,
  gitSetupHook,
  pnpm_8,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtsls";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    tag = "server-v${finalAttrs.version}";
    hash = "sha256-vlw84nigvQqRB9OQBxOmrR9CClU9M4dNgF/nrvGN+sk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    nodejs_22
    # patches are applied with git during build
    gitMinimal
    gitSetupHook
    pnpm_8.configHook
  ];

  buildInputs = [ nodejs_22 ];

  pnpmWorkspaces = [ "@vtsls/language-server" ];

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs)
      pnpmWorkspaces
      pname
      src
      version
      ;
    fetcherVersion = 1;
    hash = "sha256-SdqeTYRH60CyU522+nBo0uCDnzxDP48eWBAtGTL/pqg=";
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
