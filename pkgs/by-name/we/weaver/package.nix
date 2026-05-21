{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  testers,
  installShellFiles,
  pkg-config,
  openssl,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  python3,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tq88qWrm243Go64LpH7kU89ryq2xm9nkIJI+ZeQU7IU=";
  };

  cargoHash = "sha256-Qxx+BrioVBX5Yy6YVJAnYdNEZVqiZUJTnWNgc74sI44=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-9ifyIKFQiWKM0hzToibU4zuA64PmznqtpFWILFsFvGQ=";
  };
  pnpmRoot = "ui";

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    nodejs
    pnpmConfigHook
    pnpm
    python3
  ];

  env = {
    CXXFLAGS = "-std=c++20";
    OPENSSL_NO_VENDOR = true;
  };

  preBuild = ''
    pushd ui
    pnpm build
    popd
  '';

  checkFlags = [
    # Skip tests requiring network
    "--skip=test_cli_interface"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "OpenTelemetry tool for dealing with semantic conventions and application telemetry schemas";
    homepage = "https://github.com/open-telemetry/weaver";
    changelog = "https://github.com/open-telemetry/weaver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "weaver";
  };
})
