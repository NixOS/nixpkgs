{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "volta";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "volta-cli";
    repo = "volta";
    tag = "v${version}";
    hash = "sha256-ZI+3/Xbkg/JaZMLhrJEjaSwjs44fOaiRReM2DUTnkkc=";
  };

  cargoHash = "sha256-xlqsubkaX2A6d5MIcGf9E0b11Gzneksgku0jvW+UdbE=";

  buildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd volta \
        --bash <(${emulator} $out/bin/volta completions bash) \
        --fish <(${emulator} $out/bin/volta completions fish) \
        --zsh <(${emulator} $out/bin/volta completions zsh)
    '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  # Tries to create /var/empty/.volta as $HOME is not writable
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Hassle-Free JavaScript Tool Manager";
    longDescription = ''
      With Volta, you can select a Node engine once and then stop worrying
      about it. You can switch between projects and stop having to manually
      switch between Nodes. You can install npm package binaries in your
      toolchain without having to periodically reinstall them or figure out why
      they’ve stopped working.

      Note: Volta cannot be used on NixOS out of the box because it downloads
      Node binaries that assume shared libraries are in FHS standard locations.
    '';
    homepage = "https://volta.sh/";
    changelog = "https://github.com/volta-cli/volta/blob/main/RELEASES.md";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ fbrs ];
    mainProgram = "volta";
  };
}
