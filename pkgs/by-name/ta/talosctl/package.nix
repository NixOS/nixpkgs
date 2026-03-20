{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "talosctl";
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mGfaf64he6/eK8JMHOCUSKaAEnsxoceYWDHhsD8WQ9Q=";
  };

  vendorHash = "sha256-3po3MWqi2w2jEp+OlMQN53XUqMK4YVzv1K132TdV2bc=";

  ldflags = [
    "-s"
    "-w"
  ];

  overrideModAttrs = _: {
    buildPhase = ''
      go work vendor
    '';
  };

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      johanot
    ];
  };
})
