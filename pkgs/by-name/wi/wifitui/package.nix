{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wifitui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "wifitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JFs+7MDc0/hIDrefSRLWXurwJvvpR7LHJmCvmO1lpHA=";
  };

  vendorHash = "sha256-SEQPc13cefzT8SyuD3UmNtTDgcrXUGTX54SBrnOHJJw=";

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
