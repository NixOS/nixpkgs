{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tytanic";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "typst-community";
    repo = "tytanic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NtJrsrMwMyKQBbwjq03OaIrhfqbM+qO9C5jVCAWGmCQ=";
  };

  cargoHash = "sha256-gqIsrQLwOcs+FTVhu8lgQfISiGQVVCnmMHJTCgD9fh0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Man pages: `tt util manpage [DIR]` writes tytanic*.1 files (cf. Homebrew `system bin/"tt", "util", "manpage", man1`)
    mkdir -p ./man
    $out/bin/tt util manpage ./man
    installManPage ./man/*.1

    # Shell completions: `tt util completion <shell>` supports bash/fish/zsh (+ elvish/powershell,
    # but installShellCompletion only supports --bash/--fish/--zsh, so only those are installed)
    installShellCompletion --cmd tt \
      --bash <($out/bin/tt util completion bash) \
      --fish <($out/bin/tt util completion fish) \
      --zsh <($out/bin/tt util completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Test runner for Typst projects";
    longDescription = ''
      Tytanic is a test runner for Typst projects. It helps you worry less about
      regressions and speeds up your development.
    '';
    homepage = "https://typst-community.github.io/tytanic/";
    changelog = "https://github.com/typst-community/tytanic/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/typst-community/tytanic/releases";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "tt";
    maintainers = with lib.maintainers; [ apcamargo ];
  };
})
