{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  testers,
  installShellFiles,
  pkg-config,
  openssl,
  nodejs,
  npmHooks,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LMDJg3IKrKRPDkprwlWmBVeaZeI2dZht0eHv7eVGqjo=";
  };

  cargoHash = "sha256-EzY7OtgPDxT3g2ISV0VZTKa9kLqtKJZH4zT9v2xN/s8=";

  postPatch = ''
    # Remove build.rs to build UI separately.
    rm build.rs
  '';

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-VOL2BLTfJ1nM2L3IZpixOuAaBUHVJX032MGb3+eousY=";
  };
  npmRoot = "ui";

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    python3
  ];

  env = {
    CXXFLAGS = "-std=c++20";
    OPENSSL_NO_VENDOR = true;
  };

  preBuild = ''
    pushd ui
    npm run build
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
