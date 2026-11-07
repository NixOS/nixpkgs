{
  lib,
  stdenvNoCC,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  nix-update-script,
  runCommand,
  testers,
  fetchFromGitHub,
  fetchPnpmDeps,
  npmHooks,
  versionCheckHook,
  nixosTests,
}:
let
  pnpm = pnpm_10;
  nodejs = nodejs_24;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yaml-schema-lint";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "X-Guardian";
    repo = "yaml-schema-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ANcJOnVlznjknHPB6FUyNbm4OSyHXcmxvvJiHa+vTtw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-RgbIhSZpnStopVYwbvKBMyieLy/yBkg5zeVIaNWAOLU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    nodejs
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build
    pnpm prune --prod

    runHook postBuild
  '';

  dontNpmPrune = true;

  # A pnpm metadata embeds the build time and a random /build/tmp store path.
  # Verified by `nix-build -A yaml-schema-lint --check --keep-failed` and
  # `nix run nixpkgs#diffoscopeMinimal`
  preInstall = ''
    echo "Removing non-deterministic files"
    files="node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json"
    for file in $files; do
      rm "$file" && echo "Removed: $file"
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      nixos-test = nixosTests.yaml-schema-lint;
    };
  };

  meta = {
    description = "Lint YAML files against JSON schemas using the yaml-language-server";
    longDescription = ''
      A CLI wrapper that validates syntax and schema compliance, with schemas loaded from a settings file and
      schemastore.org.
    '';
    homepage = "https://github.com/X-Guardian/yaml-schema-lint";
    changelog = "https://github.com/X-Guardian/yaml-schema-lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcinrogacki ];
    mainProgram = "yaml-schema-lint";
    platforms = lib.platforms.unix;
  };
})
