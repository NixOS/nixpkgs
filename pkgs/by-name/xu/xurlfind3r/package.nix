{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xurlfind3r";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xurlfind3r";
    tag = finalAttrs.version;
    hash = "sha256-Zrjc6/7c8A2Bz4tgia0NGK3H4Bu2eSpHQ6TCQ2zsU3c=";
  };

  vendorHash = "sha256-4wHSArTutAIGytSWheQF8KgeLymCW3zJVr4GQN7TTXQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to discover URLs for a given domain";
    homepage = "https://github.com/hueristiq/xurlfind3r";
    changelog = "https://github.com/hueristiq/xurlfind3r/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xurlfind3r";
  };
})
