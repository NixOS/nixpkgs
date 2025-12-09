{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tygo";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "gzuidhof";
    repo = "tygo";
    rev = "v${version}";
    hash = "sha256-scda2o+aLYC4NpruEN8fZAhJuTHI9SExZv7qvAteR0M=";
  };

  vendorHash = "sha256-XQS+P+vPt2rH0SD0srFSnqjupIeu5XgFi3iVzq/ovmg=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = {
    description = "Generate Typescript types from Golang source code";
    homepage = "https://github.com/gzuidhof/tygo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexymantha ];
    mainProgram = "tygo";
  };
}
