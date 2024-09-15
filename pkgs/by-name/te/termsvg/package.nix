{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "termsvg";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mrmarble";
    repo = "termsvg";
    rev = "v${version}";
    hash = "sha256-q6xjsoxQTIQwPYkBTGwLfTt1VQ8GJPdsiP5dvTyEBIw=";
  };

  vendorHash = "sha256-HhJcf+NwM1h0Hh76LU/cddaLoCaQdyuKLSvDFmiKEEg=";

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
