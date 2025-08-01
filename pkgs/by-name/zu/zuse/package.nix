{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zuse";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "babycommando";
    repo = "zuse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zKAAHvbaR1HnRe6CmAEi/6iAOHCcbGVS1/jSrQwksRk=";
  };

  vendorHash = "sha256-P7T244d1OpFDqwRu3gdEI1OAqq9EbpL1YO2mlTw0Jew=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRC client for the terminal made in Go with Bubbletea";
    homepage = "https://github.com/babycommando/zuse";
    changelog = "https://github.com/babycommando/zuse/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "zuse";
  };
})
