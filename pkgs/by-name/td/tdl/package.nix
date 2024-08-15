{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-PX6Ja7o7K/iq7hqn0g9jZHPPRp97sHau1Xd37m8RD2A=";
  };

  vendorHash = "sha256-NNTIigd8Gm+7jJzhizaRHc4jLwO7QKhFh4ce0lrYBh4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${version}"
  ];

  # Filter out the main executable
  subPackages = [ "." ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
}
