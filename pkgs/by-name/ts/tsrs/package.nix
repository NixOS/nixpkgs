{
  lib,
  rustPlatform,
  cmake,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  oxlint,
  runCommand,
  versionCheckHook,
  nix-update-script,
  _experimental-update-script-combinators,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tsrs";
  version = "7.1.0-beta.tsrs2";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "tsrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zYiuCZLHFllXV0ENW+NE75jzba2zhBOEGwbkA38hjTA=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-ZQRhrxbt9CVAABQb41FD3HGL6PyyljPt6pfRUuK7WtI=";
  cargoBuildFlags = [
    "--package"
    "tsrs_cli"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];
  dontUseCmakeConfigure = true;

  # for tsrs_lint's tests
  nativeCheckInputs = [ nodejs ];

  preCheck = ''
    ln -s ${finalAttrs.passthru.tsRef} ts-ref
  '';

  # need ts-ref's npm dependencies
  checkFlags = [
    "--skip=api_contentmapper::node_api_transforms_content_mapped_files"
    "--skip=node_roundtrip::pinned_node_clients_round_trip"
  ];

  # upstream's wrapper for `tsrs --lint` but without requiring node
  postInstall = ''
    makeWrapper $out/bin/tsrs $out/bin/tsrs-lint --add-flags --lint
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    # commit from [workspace.metadata.typescript] in Cargo.toml
    tsRef = fetchFromGitHub {
      owner = "microsoft";
      repo = "TypeScript";
      rev = "3e9236361fa97a9e6c685f4833ac457ae2d8c50a";
      sparseCheckout = [
        "tsc/testdata/baselines/reference/astnav"
        "tsc/testdata/baselines/reference/config/tsconfigParsing"
        "tsc/testdata/baselines/reference/lsp/stackSanitizer"
        "tsc/testdata/baselines/reference/tsoptions"
        "tsc/testdata/fixtures/compiler"
        "tsc/testdata/fixtures/services"
      ];
      hash = "sha256-DE6oIFiVL+4F3/nc5dbKNE5eDLslHMS+JPfyHELIaW0=";
    };

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [ "--version-regex=^v(.+[.-]tsrs[0-9]+)$" ];
      })
      ./update-ts-ref.sh
    ];

    tests.oxlint = runCommand "tsrs-oxlint" { nativeBuildInputs = [ oxlint ]; } ''
      echo '{ "compilerOptions": { "strict": true }, "include": ["src"] }' > tsconfig.json
      mkdir src
      echo 'async function load() {} export function start() { load(); }' > src/a.ts

      OXLINT_TSGOLINT_PATH=${lib.getExe' finalAttrs.finalPackage "tsrs-lint"} \
        oxlint -A all -D typescript/no-floating-promises --type-aware -f unix src > lint.log || true
      grep -F 'typescript(no-floating-promises)' lint.log

      touch $out
    '';
  };

  meta = {
    description = "Rust port of the TypeScript 7 type checker";
    homepage = "https://github.com/oxc-project/tsrs";
    changelog = "https://github.com/oxc-project/tsrs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "tsrs";
  };
})
