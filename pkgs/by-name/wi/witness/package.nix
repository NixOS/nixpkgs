{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,

  # testing
  testers,
  witness,
}:

buildGoModule rec {
  pname = "witness";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "in-toto";
    repo = "witness";
    rev = "v${version}";
    sha256 = "sha256-0Q+6nG5N3Xp5asmRMPZccLxw6dWiZVX6fuIUf1rT+mI=";
  };
  vendorHash = "sha256-oH/aWt8Hl/BIN+IYLcuVYWDpQZaYABAOGxXyLssjQg0=";

  nativeBuildInputs = [ installShellFiles ];

  # We only want the witness binary, not the helper utilities for generating docs.
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/in-toto/witness/cmd.Version=v${version}"
  ];

  # Feed in all tests for testing
  # This is because subPackages above limits what is built to just what we
  # want but also limits the tests
  preCheck = ''
    unset subPackages
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd witness \
      --bash <($out/bin/witness completion bash) \
      --fish <($out/bin/witness completion fish) \
      --zsh <($out/bin/witness completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = witness;
    command = "witness version";
    version = "v${version}";
  };

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
    changelog = "https://github.com/testifysec/witness/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fkautz
      jk
    ];
  };
}
