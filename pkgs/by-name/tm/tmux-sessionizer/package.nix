{
  fetchFromGitHub,
  installShellFiles,
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmux-sessionizer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = "tmux-sessionizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6eMKwp5639DIyhM6OD+db7jr4uF34JSt0Xg+lpyIPSI=";
  };

  cargoHash = "sha256-gIsqHbCmfYs1c3LPNbE4zLVjzU3GJ4MeHMt0DC5sS3c=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tms \
      --bash <(COMPLETE=bash $out/bin/tms) \
      --fish <(COMPLETE=fish $out/bin/tms) \
      --zsh <(COMPLETE=zsh $out/bin/tms)
  '';

<<<<<<< HEAD
  meta = {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      vinnymeller
      mrcjkb
    ];
    mainProgram = "tms";
  };
})
