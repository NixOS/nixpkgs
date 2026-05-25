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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = "tmux-sessionizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tJ8aKajSWc62BZ8hb3u+OQtlu04z8Ala5nAK5H4Byp4=";
  };

  cargoHash = "sha256-AJqlzLr6MDFfPssSFMxslxFFuPVxoQGcuG7sZeu+8pg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
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

  meta = {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vinnymeller
      mrcjkb
    ];
    mainProgram = "tms";
  };
})
