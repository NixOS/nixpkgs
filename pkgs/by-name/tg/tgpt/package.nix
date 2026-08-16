{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "tgpt";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bIIWzXdLneXQSwAGIAYv5GaSc9vtFIrOCscCt9qLZWs=";
  };

  vendorHash = "sha256-9uQvS6XZ3iEjtF9jygPLPJJwCiWaXzTrkjdANlvll+o=";

  buildInputs = [ libx11 ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Remove test which need network access
    rm src/providers/koboldai/koboldai_test.go
  '';

  meta = {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tgpt";
  };
})
