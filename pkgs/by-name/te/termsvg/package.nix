{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "termsvg";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "MrMarble";
    repo = "termsvg";
    rev = "v${version}";
    hash = "sha256-tNvr8ptMortP7iI6GwT4AGbqTvNFposca8I2JribGnk=";
  };

  vendorHash = "sha256-BoXRLWhQmfvMIN658MiXGCFMbnvuXfv/H/jCE6h4aWk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "Record, share and export your terminal as a animated SVG image";
    homepage = "https://github.com/MrMarble/termsvg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "termsvg";
  };
}
