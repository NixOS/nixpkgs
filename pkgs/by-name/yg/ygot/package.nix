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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = "ygot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O8nBcXRKKd+dV0jub5tVvG8WoxGMR4r1cqOmTzO+LDU=";
  };

  vendorHash = "sha256-AgSKfy8Dbc5fRhJ2oskmkShL/mHb2FKkGZoqPyagLfE=";

  excludedPackages = [
    "demo/*"
    "exampleoc"
    "integration_tests/"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/gnmidiff"
        else
          lib.getExe' buildPackages.ygot "gnmidiff";
    in
    ''
      # The normal binary names are far too generic
      mv $out/bin/generator $out/bin/ygot_generator
      mv $out/bin/proto_generator $out/bin/ygot_proto_generator
        installShellCompletion --cmd gnmidiff \
          --bash <(${exe} completion bash) \
          --zsh <(${exe} completion zsh) \
          --fish <(${exe} completion fish)
    '';

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
