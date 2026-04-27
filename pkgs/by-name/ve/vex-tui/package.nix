{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "vex-tui";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "CodeOne45";
    repo = "vex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zvk9rcUyRwLzjy151ucEDv3upeuIOmklmh7FqTkSCg0=";
  };

  vendorHash = "sha256-jE53+VEjj5E5G2Yycwb8NDA8vDtoUtarrQgZ9ULyVh0=";

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
