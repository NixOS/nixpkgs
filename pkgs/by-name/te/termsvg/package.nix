{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "termsvg";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "mrmarble";
    repo = "termsvg";
    rev = "v${version}";
    hash = "sha256-y07C82yzgQ1i04le+l/KM/Oty+5BH6S9mA0xFuIIe0o=";
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
    homepage = "https://github.com/mrmarble/termsvg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "termsvg";
  };
}
