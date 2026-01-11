{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wifitui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "wifitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZhVMcpua9foigtkaN4EFjugwrEwUBOkXGLIIAaq9+zs=";
  };

  vendorHash = "sha256-HZEE8bJC9bsSYmyu7NBoxEprW08DO5+uApVnyNkKgMk=";

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Fast featureful friendly wifi terminal UI";
    mainProgram = "wifitui";
    homepage = "https://github.com/shazow/wifitui";
    changelog = "https://github.com/shazow/wifitui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shazow
    ];
    # wifitui has partial/experimental darwin support but mainly linux focused;
    # if someone needs this then would appreciate a darwin co-maintainer,
    # see: https://github.com/shazow/wifitui/issues/49
    platforms = lib.platforms.linux;
  };
})
