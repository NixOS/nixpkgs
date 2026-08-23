{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "usbguard-tui";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "anotherhadi";
    repo = "usbguard-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z72ZQ1jYFK9itc93fBVQUQJbx2Iw4K1l1k3GCbUO8AU=";
  };

  vendorHash = "sha256-O9DG0pxRKt8VwpZdyvoQ4wsfEbsh5npmwocmtcm2IfA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Terminal UI for managing USB devices via usbguard, with keybindings & mouse support";
    homepage = "https://github.com/anotherhadi/usbguard-tui";
    changelog = "https://github.com/anotherhadi/usbguard-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anotherhadi ];
    mainProgram = "usbguard-tui";
    platforms = lib.platforms.linux;
  };
})
