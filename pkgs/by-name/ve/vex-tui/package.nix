{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "vex-tui";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "CodeOne45";
    repo = "vex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rxpC+WyBlDELT8cfnTVkW8V6+z1mIultGhw/DoFOblQ=";
  };

  postInstall = ''
    mv $out/bin/{vex-tui,vex}
  '';

  vendorHash = "sha256-PvaV0tJjIVppB36Cxg4aAKX0MBjgFC5S4GTs1zHxCCU=";

  meta = {
    description = "Beautiful, fast, and feature-rich terminal-based Excel and CSV viewer built with Go";
    homepage = "https://github.com/CodeOne45/vex-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    mainProgram = "vex";
  };
})
