{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ygot";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = "ygot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YEL0c3bd8HnpjSrnWduq9Qkrrq9x3bIcEMBUMFIM4ms=";
  };

  vendorHash = "sha256-WYlITTyY6hGKn+lyr8FRdo/c8kcOYd9qJb3pDKBqwak=";

  excludedPackages = [
    "demo/*"
    "exampleoc"
    "integration_tests/"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # The normal binary names are far too generic
    mv $out/bin/generator $out/bin/ygot_generator
    mv $out/bin/proto_generator $out/bin/ygot_proto_generator
  ''
  + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gnmidiff \
        --bash <(${emulator} $out/bin/gnmidiff completion bash) \
        --zsh <(${emulator} $out/bin/gnmidiff completion zsh) \
        --fish <(${emulator} $out/bin/gnmidiff completion fish)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of Go utilities for interacting with YANG modules";
    homepage = "https://github.com/openconfig/ygot";
    changelog = "https://github.com/openconfig/ygot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "ygot_generator";
  };
})
