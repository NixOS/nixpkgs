{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${version}";
    hash = "sha256-LE6wwGEsqI/wfD21FiLpEo5fc7V0uGkN+hUPeAXCOZE=";
  };

  vendorHash = "sha256-hPbvzhYHOxytQs3NkSVaZhFH0TbOlr4U/QiH+vemTrc=";

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Remove test which need network access
    rm providers/koboldai/koboldai_test.go
    rm providers/phind/phind_test.go
  '';

  meta = {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tgpt";
  };
}
