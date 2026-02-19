{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  tailer,
}:

buildGoModule (finalAttrs: {
  pname = "tailer";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hionay";
    repo = "tailer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gPezz2ksqdCffgdAHwU2NMTar2glp5YGfA5C+tMYPtE=";
  };

  vendorHash = "sha256-nQqSvfN+ed/g5VkbD6XhZNA1G3CGGfwFDdadJ5+WoD0=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = tailer;
    };
  };

  meta = {
    description = "CLI tool to insert lines when command output stops";
    homepage = "https://github.com/hionay/tailer";
    maintainers = with lib.maintainers; [ liberodark ];
    license = lib.licenses.mit;
    mainProgram = "tailer";
  };
})
