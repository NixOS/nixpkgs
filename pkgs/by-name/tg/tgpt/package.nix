{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    rev = "refs/tags/v${version}";
    hash = "sha256-XuTDEcs1wIrAe7Oaok4aFP01jDcyWB01R3HNrx6UEpo=";
  };

  vendorHash = "sha256-docq/r6yyMPsuUyFbtCMaYfEVL0gLmyTy4PbrAemR00=";

  ldflags = [
    "-s"
    "-w"
  ];

  # test tries to access the network
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "tgpt";
  };
}
