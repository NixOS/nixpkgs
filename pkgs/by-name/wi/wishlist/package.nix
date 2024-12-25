{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wishlist";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-53fojA+gdvpSVNjx6QncH16F8/x+lpY5SkNs7obW2XQ=";
  };

  vendorHash = "sha256-VB515IK9ZJYC08EmShOPbLKU0fHZ16Dw+c5hiZ7mW8Q=";

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
