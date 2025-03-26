{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pacman,
  libarchive,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "yay";
  version = "12.4.2";

  src = fetchFromGitHub {
    owner = "Jguer";
    repo = "yay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QLkqpeHVdR9dxhSGl2wQ7WL1mX6JJm3z6pLeI37z3oM=";
  };

  vendorHash = "sha256-BKxhRa2y/liBDtMLg0Rlf/ysjQOgIaFjXbPWYBw53Po=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    pacman
    libarchive
  ];

  env.CGO_ENABLED = 1;

  checkFlags =
    let
      skippedTests = [
        # need fhs
        "TestAlpmExecutor"
        "TestBuildRuntime"
        "TestPacmanConf"
        # need su/sudo/doas
        "TestNewConfig"
        "TestNewConfigAURDEST"
        "TestNewConfigAURDESTTildeExpansion"
        "TestConfiguration_setPrivilegeElevator"
        "TestConfiguration_setPrivilegeElevator_su"
        "TestConfiguration_setPrivilegeElevator_no_path"
        "TestConfiguration_setPrivilegeElevator_doas"
        "TestConfiguration_setPrivilegeElevator_pacman_auth_doas"
        "TestConfiguration_setPrivilegeElevator_custom_script"
        "TestConfiguration_setPrivilegeElevator_pacman_auth_sudo"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall =
    ''
      installManPage doc/yay.8
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --name yay.bash --bash completions/bash
      installShellCompletion --name yay.fish --fish completions/fish
      installShellCompletion --name _yay --zsh completions/zsh
    '';

  meta = {
    description = "AUR Helper written in Go";
    homepage = "https://github.com/Jguer/yay";
    mainProgram = "yay";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
