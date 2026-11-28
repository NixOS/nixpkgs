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
  version = "7.1.0-beta.tsrs4";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "tsrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2mpUgsvLbBMxrfSQ48CsdfFyqpMSrVVsADV7OYdKeOs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-heb8kmr7tNZ2e8YhbBiqhlymU7ocJBHGpQfU3E3FIk4=";
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

  checkFlags = [
    # need ts-ref's npm dependencies
    "--skip=api_contentmapper::node_api_transforms_content_mapped_files"
    "--skip=node_roundtrip::pinned_node_clients_round_trip"
    # timing-sensitive
    "--skip=checker::lease_tests::async_two_waits_in_one_request_each_get_the_full_grace_period"
    "--skip=reentrancy::sequential_acquisitions_do_not_inherit_a_previous_wait"
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
      sparseCheckout = [ "tsc/testdata" ];
      hash = "sha256-0a0fOWHhyIHXtrRz/jj3BbglbmEnyPsMqhZez0aipgM=";
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
