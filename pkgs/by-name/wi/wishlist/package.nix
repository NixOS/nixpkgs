{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wishlist";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-LozGwgm/LGOzCa+zKC77NX40etzT4PDeuw3yh1QMmMY=";
  };

  vendorHash = "sha256-QdMS1C8I3Ul5q6HQOw7+alinPo0yIZ4s7yIxQ/poEik=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      caarlos0
      penguwin
    ];
    mainProgram = "wishlist";
  };
}
