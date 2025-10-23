{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,

  buildPackages,
  installShellFiles,

  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "witness";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "in-toto";
    repo = "witness";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-MKiPIZFeCWOT4zTbG7SjwdNUHFuqsL4pGu4VvVwyn3s=";
  };
  vendorHash = "sha256-V3SuhBbhXyA0SFOGfBrV/qH+cROr2obHOBcivkgRO6U=";

  nativeBuildInputs = [ installShellFiles ];

  # We only want the witness binary, not the helper utilities for generating docs.
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/in-toto/witness/cmd.Version=${finalAttrs.src.tag}"
  ];

  # Feed in all tests for testing
  # This is because subPackages above limits what is built to just what we
  # want but also limits the tests
  preCheck = ''
    unset subPackages
    # tests expect no version set
    unset ldflags
  '';

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/witness"
        else
          lib.getExe buildPackages.witness;
    in
    ''
      installShellCompletion --cmd witness \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Pluggable framework for software supply chain security. Witness prevents tampering of build materials and verifies the integrity of the build process from source to target";
    longDescription = ''
      Witness prevents tampering of build materials and verifies the integrity
      of the build process from source to target. It works by wrapping commands
      executed in a continuous integration process. Its attestation system is
      pluggable and offers support out of the box for most major CI and
      infrastructure providers. Verification of Witness metadata and a secure
      PKI distribution system will mitigate against many software supply chain
      attack vectors and can be used as a framework for automated governance.
    '';
    mainProgram = "witness";
    homepage = "https://github.com/testifysec/witness";
    changelog = "https://github.com/testifysec/witness/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fkautz
      jk
    ];
  };
})
