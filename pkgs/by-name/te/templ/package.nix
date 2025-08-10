{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "templ";
  version = "0.3.924";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-CdBZRF+Q4q/BFPFuY/DQ8V3giM5iTtadM31ta1JF5OE=";
  };

  vendorHash = "sha256-oObzlisjvS9LeMYh3DzP+l7rgqBo9bQcbNjKCUJ8rcY=";

  subPackages = [ "cmd/templ" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = {
    description = "Language for writing HTML user interfaces in Go";
    homepage = "https://github.com/a-h/templ";
    license = lib.licenses.mit;
    mainProgram = "templ";
    maintainers = with lib.maintainers; [ luleyleo ];
  };
}
