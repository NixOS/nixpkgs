{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "vex-tui";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "CodeOne45";
    repo = "vex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NHGqfdto2geJD9FUFMC/MEpGocNrRN8gtJ0J/6kSJkc=";
  };

  vendorHash = "sha256-PvaV0tJjIVppB36Cxg4aAKX0MBjgFC5S4GTs1zHxCCU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{vex-tui,vex}
  '';

  meta = {
    description = "Beautiful, fast, and feature-rich terminal-based Excel and CSV viewer built with Go";
    homepage = "https://github.com/CodeOne45/vex-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
  };
})
