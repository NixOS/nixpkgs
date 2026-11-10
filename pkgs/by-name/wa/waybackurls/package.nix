{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "waybackurls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "waybackurls";
    tag = "v${version}";
    hash = "sha256-aX6pCEp2809oYn1BUwdfKzJzMttnZItGXC1QL4yMztg=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to fetch all the URLs that the Wayback Machine knows about for a domain";
    homepage = "https://github.com/tomnomnom/waybackurls";
    changelog = "https://github.com/tomnomnom/waybackurls/releases/tag/${src.tag}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "waybackurls";
  };
}
