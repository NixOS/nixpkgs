{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "y509";
  version = "1.0.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kanywst";
    repo = "y509";
    tag = "v${finalAttrs.version}";
    hash = "sha256-se3Zlj/+AYK+6ay1jdvb5HRRy8trFpmLyqjofiywlI8=";
  };

  vendorHash = "sha256-TEunzNuyN6n4fWYhJsEnTgj6KK/CEQkZ78baGtLH4zA=";

  subPackages = [ "cmd/y509" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X=github.com/kanywst/y509/internal/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    installManPage man/man1/y509.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd y509 \
      --bash <($out/bin/y509 completion bash) \
      --fish <($out/bin/y509 completion fish) \
      --zsh <($out/bin/y509 completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for inspecting and validating X.509 certificate chains";
    longDescription = ''
      y509 verifies a certificate chain against the system trust store and
      separately reports how the chain was served: a missing intermediate, a
      redundant root, or certificates sent out of order. Chains can be read
      from PEM/DER files, from stdin, or from a live server, including behind
      STARTTLS. The validate subcommand exits non-zero on anything a TLS client
      would reject, with optional JSON output for CI.
    '';
    homepage = "https://github.com/kanywst/y509";
    changelog = "https://github.com/kanywst/y509/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kanywst ];
    mainProgram = "y509";
  };
})
