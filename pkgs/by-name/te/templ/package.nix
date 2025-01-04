{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "templ";
  version = "0.3.819";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-kTP/DLnou3KETZRtvHdeiMmRW6xldgZBAn9O9p9s/MA=";
  };

  vendorHash = "sha256-ipLn52MsgX7KQOJixYcwMR9TCeHz55kQQ7fgkIgnu7w=";

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
