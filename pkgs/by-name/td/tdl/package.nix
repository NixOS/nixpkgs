{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-30OClBZUjoLvZ0ZhSZx+AaS7fhjo8X392t4FQpxoG9Q=";
  };

  vendorHash = "sha256-QBqUa/PnT/Xma3SHq6YRGtVNKstTax1GVRsCDU12ETA=";

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
