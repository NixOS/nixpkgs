{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  runCommand,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termframe";
  version = "0.8.5";

  __structuredAttrs = true;

  cargoHash = "sha256-Ws+0L752D/ESOZJe9RU63TGlKfpGsS2DxKy+8uYmCfw=";

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "termframe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+odV1mkUtObSV8LiDJn5MmT3xBm42XScHulFk23KB4=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage --name termframe.1 <($out/bin/termframe --man-page)

    installShellCompletion --cmd termframe \
     --bash <($out/bin/termframe --shell-completions bash) \
     --fish <($out/bin/termframe --shell-completions fish) \
     --zsh <($out/bin/termframe --shell-completions zsh)
  '';

  passthru = {
    tests = {
      echo = runCommand "${finalAttrs.pname}-tests-echo" { } ''
        mkdir $out
        ${finalAttrs.finalPackage}/bin/termframe --mode dark --font-family "My Test Font" --output "$out/hello.svg" -- echo 'Hello, World!'
        grep --quiet 'Hello, World' "$out/hello.svg"
        grep --quiet 'My Test Font' "$out/hello.svg"
      '';
    };
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Terminal output SVG screenshot tool";
    longDescription = "A non-interactive terminal emulator that executes a single command, renders its output in an internal virtual session, and exports a screenshot as an SVG file.";
    homepage = "https://github.com/pamburus/termframe";
    changelog = "https://github.com/pamburus/termframe/releases";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ilai-deutel ];
    mainProgram = "termframe";
  };
})
