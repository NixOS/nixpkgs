{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  python3,
  util-linux,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "whykey";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "agustinrojas1";
    repo = "whykey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-grcCXr12UvBWQuTxiKBwWn4p7NDKsgfnLaUaBWBIM7I=";
  };

  cargoHash = "sha256-tjQx88IIAm+f2bvba1zRolqcWeutfKPTr4j1I8ynqWM=";

  # The editor extensions and their test fixtures are `#!/usr/bin/env python3`
  # scripts; the tests run them, and the installed extensions need python3.
  postPatch = ''
    patchShebangs extensions tests/fixtures
  '';

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ python3 ];
  nativeCheckInputs = [
    python3
    util-linux
  ];

  checkFlags = [
    # Spawns `sleep` with argv[0] set to `vim`, which the multi-call coreutils
    # binary rejects as an unknown program.
    "--skip=layers::application::tests::unmapped_vim_keeps_the_key_flowing_as_uncertain"
  ];

  postInstall = ''
    install -Dm755 extensions/whykey-nvim extensions/whykey-vscode extensions/whykey-emacs -t $out/bin
    # whykey-vscode looks for its defaults table in ../share/whykey.
    install -Dm644 extensions/whykey-vscode-defaults.json -t $out/share/whykey
    installManPage whykey.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Explain where a Linux key combination is handled";
    homepage = "https://github.com/agustinrojas1/whykey";
    changelog = "https://github.com/agustinrojas1/whykey/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ agustinrojas1 ];
    mainProgram = "whykey";
    platforms = lib.platforms.linux;
  };
})
