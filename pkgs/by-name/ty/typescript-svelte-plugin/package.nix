{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  nix-update-script,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  stdenv,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "typescript-svelte-plugin";
  version = "0.3.52";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "sveltejs";
    repo = "language-tools";
    tag = "typescript-svelte-plugin@${finalAttrs.version}";
    hash = "sha256-qcY8ikS7spfbMk1zJ1pu+yyBsFYIFCWB/YqANyCZrVc=";
  };

  pnpmWorkspaces = [ "typescript-svelte-plugin..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-u78ndXZcWIjJbn6lu010/0IWIWtqvFTYgrTZ++JWiQE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run --filter=typescript-svelte-plugin... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm config set --location=project inject-workspace-packages true
    pnpm --filter=typescript-svelte-plugin \
      deploy $out/lib/node_modules/typescript-svelte-plugin/

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    node -e "require('$out/lib/node_modules/typescript-svelte-plugin')"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "typescript-svelte-plugin@(.*)"
    ];
  };

  meta = {
    description = "TypeScript plugin providing Svelte IntelliSense";
    homepage = "https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin";
    changelog = "https://github.com/sveltejs/language-tools/blob/typescript-svelte-plugin@${finalAttrs.version}/packages/typescript-plugin/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Tenshock ];
  };
})
