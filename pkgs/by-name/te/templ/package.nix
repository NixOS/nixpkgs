{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "templ";
  version = "0.3.865";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-ngdn5ftTunVUIOwmovYgIlGkyrYjXSJkp+0fJEHXB+s=";
  };

  vendorHash = "sha256-q4L+r6S0eMNd5hP9UQCI+GxSJoiMGpjd0UTxA8zb6KU=";

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
